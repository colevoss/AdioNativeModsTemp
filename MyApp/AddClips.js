import React, { useState } from 'react';
import { View, Text, Button, FlatList } from 'react-native';
import { useSession, useSessionState } from '../AdioSession';
import { clips as clipsData } from '../data';

export function AddClips() {
  const session = useSession();
  const sessionState = useSessionState();
  const [added, setAdded] = useState(false);

  const onPress = () => {
    setAdded(true);
    session
      .addClips(clipsData)
      .then(console.log)
      .catch(console.warn);
  };

  const clips = sessionState.downloadingClips;

  return (
    <View>
      <Button
        title={added ? 'Clips Added' : 'Add Clips'}
        onPress={onPress}
        disabled={added}
      />
      <FlatList
        keyExtractor={(item) => item.id}
        ListEmptyComponent={() => <Text>No Downloading Clips</Text>}
        data={Object.values(clips)}
        renderItem={({ item }) => {
          return (
            <View>
              <Text>
                {item.id}: {Math.round(item.progress * 100)}%
              </Text>
            </View>
          );
        }}
      />
    </View>
  );
}
