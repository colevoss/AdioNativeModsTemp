import { useState, useEffect } from 'react';
import { useSession } from '../SessionContext';

export function useSessionStatus() {
  const session = useSession();
  const [status, setStatus] = useState(null);

  useEffect(() => {
    const sub = session.onStatusChange(setStatus);

    return sub.remove;
  }, [session.sessionId]);

  return status;
}
