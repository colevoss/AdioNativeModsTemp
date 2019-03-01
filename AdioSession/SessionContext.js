import React, {
  useContext,
  useState,
  createContext,
  useEffect,
  useRef,
} from 'react';
import Session from './Session';

const SessionContext = createContext(null);

export { SessionContext };

export function SessionProvider({ sessionId, children }) {
  const sessionRef = useRef();
  const [state, setState] = useState(false);

  const initSession = async () => {
    const session = new Session(sessionId);

    await session.init();

    sessionRef.current = session;
    setState(session.hasSession);
  };

  useEffect(() => {
    initSession();

    return () => {
      if (!sessionRef.current) return;

      return sessionRef.current.destroy();
    };
  }, [sessionId]);

  if (!state) return null;

  return (
    <SessionContext.Provider value={sessionRef.current}>
      {children}
    </SessionContext.Provider>
  );
}

export function useSession() {
  const session = useContext(SessionContext);

  return session;
}
