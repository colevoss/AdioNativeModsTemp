import { useState, useEffect } from 'react';
import { useSession } from '../SessionContext';

export function useSessionSeekTime() {
  const session = useSession();
  const [seekTime, setSeekTime] = useState(0);

  useEffect(() => {
    const sub = session.onSeekTimeUpdated(setSeekTime);

    return sub.remove;
  }, [session.sessionId]);

  return seekTime;
}
