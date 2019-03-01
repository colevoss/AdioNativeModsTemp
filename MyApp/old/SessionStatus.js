import React from 'react';
import { View, Text } from 'react-native';
import { useSessionStatus } from '../AdioSession/useSessionStatus';

const SessionStatus = () => {
  const { loading, status } = useSessionStatus();

  if (loading) {
    return (
      <View>
        <Text>Status: Loading Status</Text>
      </View>
    );
  }

  return (
    <View>
      <Text>Status: {status || 'Nothing Yet'}</Text>
    </View>
  );
};

export default SessionStatus;
