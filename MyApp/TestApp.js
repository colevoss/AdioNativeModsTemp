import React from 'react';
import { View, SafeAreaView } from 'react-native';
import { SessionProvider } from '../AdioSession/SessionContext';
import { SessionStateProvider } from '../AdioSession/SessionStateContext';
import { AddClips } from './AddClips';
import { Play } from './Play';

const TestApp = ({ sessionId }) => {
  return (
    <SafeAreaView style={{ padding: 24, flex: 1 }}>
      <SessionProvider sessionId={sessionId}>
        <SessionStateProvider>
          <View style={{ flex: 1 }}>
            <Play />
            <AddClips />
          </View>
        </SessionStateProvider>
      </SessionProvider>
    </SafeAreaView>
  );
};

export default TestApp;
