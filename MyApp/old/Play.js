import React from 'react';
import { View, Button } from 'react-native';
import { useSession, useSessionStatus } from '../AdioSession';

export default function Play() {
  const session = useSession();
  const sessionStatus = useSessionStatus();

  if (sessionStatus.loading) return null;

  const onPress = () => {
    if (sessionStatus.status !== 'Playing') {
      session.play();
    } else {
      session.stop();
    }
  };

  return (
    <View>
      <Button
        onPress={onPress}
        title={sessionStatus.status === 'Playing' ? 'Stop' : 'Play'}
        disabled={sessionStatus.status === 'Busy'}
      />
    </View>
  );
}
