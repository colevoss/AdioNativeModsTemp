import { useState, useEffect } from 'react';
import { useSession } from '../SessionContext';

export function useSessionPlaybackTime() {
  const session = useSession();
  const [playbackTime, setPlaybackTime] = useState(0);

  useEffect(() => {
    const sub = session.onPlaybackTimeUpdated(setPlaybackTime);

    return sub.remove;
  }, [session.sessionId]);

  return playbackTime;
}
