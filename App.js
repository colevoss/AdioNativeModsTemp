/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from 'react';
import { Button, StyleSheet, View } from 'react-native';
import TestApp from './MyApp/TestApp';
export default class App extends Component<Props> {
  state = {
    sessionId: null,
  };

  render() {
    return (
      <View style={styles.container}>
        {this.state.sessionId && <TestApp sessionId={this.state.sessionId} />}
        {this.state.sessionId && (
          <Button
            title="CLOSE"
            onPress={() => this.setState(() => ({ sessionId: null }))}
          />
        )}

        {!this.state.sessionId && (
          <Button
            title={'Start'}
            onPress={() => this.setState(() => ({ sessionId: 'anything' }))}
          />
        )}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
