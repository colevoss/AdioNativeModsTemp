import React from 'react';
import { View, Text } from 'react-native';
import { usePlaybackTime } from '../AdioSession';

export default function SeekTime() {
  const { loading, playbackTime } = usePlaybackTime();

  return (
    <View>
      <Text>Playback: {loading ? '--:--' : playbackTime}</Text>
    </View>
  );
}
