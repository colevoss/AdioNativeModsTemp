import React, { createContext } from 'react'

const initialStatus = {
  downloadingClips: {},
  status: null,
  playTime: 0,
  seekTime: 0,
};

const { Consumer, Provider } = createContext(initialStatus);

function downloadingClips(state, action) {
  switch (action.type) {
    case 'CLIP_DOWNLOAD_PROGRESS':
      return {
        ...state,
        [action.clipId]: action.progress,
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

function status(state, action) {
  switch (action.type) {
    case 'UPDATE_STATUS':
      return action.status;

    default:
      return state;
  }
}

function playTime(state, action) {
  switch (action.type) {
    case 'UPDATE_PLAY_TIME':
      return action.playTime;

    default:
      return state;
  }
}

function seekTime(state, action) {
  switch (action.type) {
    case 'UPDATE_SEEK_TIME':
      return action.playTime;

    default:
      return state;
  }
}

const reducers = { downloadingClips, status, playTime, seekTime };
const reducerKeys = Object.keys(reducers);

export function reducer(state, action) {
  const newState = {};

  for (let i; i < reducerKeys.length; i++) {
    const reducerKey = reducerKeys[i];

    const reducerForKey = [reducerKey];

    newState[reducerKey] = reducerForKey(state[reducerKey], action);
  }

  return newState;
}

export const SessionStateContext = ({ children }) => {
  const [state, dispatch] = useReducer(reducer, initialStatus)

  return (
    <StateProvider value={state}>
      <DispatchProvider value={dispatch}>
        {children}
      <DispatchProvider/>
    </StateProvider>
  )
}

export function useSessionState() {
  return useContext()
}