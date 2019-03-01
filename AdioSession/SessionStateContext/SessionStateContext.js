import React, { useMemo, useContext } from 'react';
import { useSessionClips } from './useSessionClips';
import { useSessionPlaybackTime } from './useSessionPlaybackTIme';
import { useSessionSeekTime } from './useSessionSeekTime';
import { useSessionStatus } from './useSessionStatus';

const SessionStateContext = React.createContext({});

export { SessionStateContext };

function useSessionStateValue() {
  const status = useSessionStatus();
  const seekTime = useSessionSeekTime();
  const playbackTime = useSessionPlaybackTime();
  const downloadingClips = useSessionClips();

  const stateValue = useMemo(() => {
    return {
      status,
      seekTime,
      playbackTime,
      downloadingClips,
    };
  }, [status, seekTime, playbackTime, downloadingClips]);

  return stateValue;
}

export function SessionStateProvider({ children }) {
  const stateValue = useSessionStateValue();

  return (
    <SessionStateContext.Provider value={stateValue}>
      {children}
    </SessionStateContext.Provider>
  );
}

export function useSessionState() {
  return useContext(SessionStateContext);
}
