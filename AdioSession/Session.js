import { NativeModules, NativeEventEmitter } from 'react-native';

const { AdioSession } = NativeModules;
const AdioSessionEvents = new NativeEventEmitter(AdioSession);

export default class Session {
  hasSession = false;
  sessionId = null;

  constructor(sessionId) {
    this.sessionId = sessionId;
  }

  async init() {
    return AdioSession.createAudioSession(this.sessionId)
      .then(() => {
        this.hasSession = true;
        // this.sessionId = sessionId;
      })
      .catch((e) => {
        console.log(e);
        this.hasSession = false;
      });
  }

  destroy() {
    return AdioSession.destroyAudioSession();
  }

  getSeekTime() {
    return AdioSession.getSeekTime();
  }

  getStatus() {
    return AdioSession.getSessionStatus();
  }

  getPlaybackTime() {
    return AdioSession.getPlaybackTime();
  }

  play() {
    AdioSession.play();
  }

  stop() {
    AdioSession.stop();
  }

  setSeekTime(seekTime) {
    return AdioSession.setSeekTime(seekTime);
  }

  addClip(clip) {
    return AdioSession.addClip(clip);
  }

  addClips(clips) {
    return AdioSession.addClips(clips);
  }

  onPlaybackTimeUpdated(handler) {
    return AdioSessionEvents.addListener('playbackTimeUpdated', handler);
  }

  onSeekTimeUpdated(handler) {
    return AdioSessionEvents.addListener('seekTimeUpdated', handler);
  }

  onStatusChange(handler) {
    return AdioSessionEvents.addListener('audioSessionStatusUpdated', handler);
  }

  onClipDownloadProgress(handler) {
    return AdioSessionEvents.addListener('clipDownloadProgress', handler);
  }

  onClipDownloaded(handler) {
    return AdioSessionEvents.addListener('clipDownloaded', handler);
  }
}
