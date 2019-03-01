import { useReducer, useEffect } from 'react';
import { useSession } from '../SessionContext';

export function downloadingClipsReducer(state, action) {
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

export function useSessionClips() {
  const session = useSession();
  const [clipsState, dispatch] = useReducer(downloadingClipsReducer, {});

  useEffect(() => {
    const progressSub = session.onClipDownloadProgress(({ id, progress }) => {
      dispatch({ type: 'CLIP_DOWNLOAD_PROGRESS', clipId: id, progress });
    });

    const completeSub = session.onClipDownloaded((clip) => {
      dispatch({ type: 'CLIP_DOWNLOADED', clipId: clip.id });
    });

    return () => {
      progressSub.remove();
      completeSub.remove();
    };
  }, [session.sessionId]);

  return clipsState;
}
