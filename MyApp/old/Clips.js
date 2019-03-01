import React, { useState, useEffect, useReducer } from 'react';
import { View, FlatList, Text, Button } from 'react-native';
import { useSession } from '../AdioSession';
import { clips as clipsData } from '../data';

// console.log(clipsData);

function reducer(state, action) {
  switch (action.type) {
    case 'CLIP_DOWNLOAD_PROGRESS':
      return {
        ...state,
        [action.clipId]: {
          progress: action.progress,
          id: action.clipId,
        },
      };

    case 'CLIP_DOWNLOADED':
      return Object.keys(state).reduce((clips, clipId) => {
        if (clipId === action.clipId) return clips;

        return {
          ...clips,
          [clipId]: state[clipId],
        };
      }, {});

    default:
      return state;
  }
}

export default function Clips() {
  const session = useSession();
  const [state, setState] = useState(false);
  const [clips, dispatch] = useReducer(reducer, {});

  const onPress = () => {
    setState(true);

    session
      .addClips(clipsData)
      .then(console.log)
      .catch(console.error);
  };

  useEffect(() => {
    const progressSub = session.onClipDownloadProgress(({ id, progress }) => {
      dispatch({ type: 'CLIP_DOWNLOAD_PROGRESS', clipId: id, progress });
    });

    const finishedSub = session.onClipDownloaded(({ id }) => {
      dispatch({ type: 'CLIP_DOWNLOADED', clipId: id });
    });

    return () => {
      progressSub.remove();
      finishedSub.remove();
    };
  }, [session.sessionId]);

  return (
    <View>
      <Button title="Add Clips" onPress={onPress} disabled={state} />
      <FlatList
        keyExtractor={(item) => item.id}
        ListEmptyComponent={() => <Text>No Downloading Clips</Text>}
        data={Object.values(clips)}
        renderItem={({ item }) => {
          return (
            <View>
              <Text>{item.id}</Text>
              <Text>{item.progress}</Text>
            </View>
          );
        }}
      />
    </View>
  );
}
