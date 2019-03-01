import React from 'react';
import { View, Text, Button } from 'react-native';
import { useSession, useSessionState } from '../AdioSession';

const playTime = (time) => {
  const seconds = time % 60;
  const millis = Math.round((seconds - Math.floor(seconds)) * 100) / 100;
  const minutes = Math.floor(time / 60);

  return `${minutes} : ${Math.floor(seconds)}.${millis}`;
};

export function Play() {
  const session = useSession();
  const sessionState = useSessionState();

  const { status, seekTime, playbackTime } = sessionState;
  const time = playTime(status === 'Playing' ? playbackTime : seekTime);

  return (
    <View>
      <Text>{time}</Text>
      <Button
        title={status !== 'Playing' ? 'Play' : 'Stop'}
        disabled={status === 'Busy'}
        onPress={() => (status !== 'Playing' ? session.play() : session.stop())}
      />
    </View>
  );
}
