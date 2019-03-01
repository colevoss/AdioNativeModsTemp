//
//  AdioSession+Session.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

extension AdioSession: SessionDelegate {
  @objc
  func play() {
    Logger.debug("PLAY!!!")
    AdioSession.session?.play()
  }
  
  @objc
  func stop() {
    AdioSession.session?.stop()
  }
  
  @objc
  func setSeekTime(_ seekTime: Float, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    AdioSession.session?.setSeekTime(seekTime)
    
    resolve(AdioSession.session?.seekTime)
  }
  
  @objc
  func getSeekTime(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    guard let session = AdioSession.session else {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_SESSION_EXISTS", "An audio session has not been created to get seekTime from", error)
      return
    }
    
    resolve(session.seekTime)
  }
  
  @objc
  func getPlaybackTime(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    guard let session = AdioSession.session else {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_SESSION_EXISTS", "An audio session has not been created to get playbackTime from", error)
      return
    }
    
    let time = session.status == .Playing ? session.currentTime : session.seekTime
    
    resolve(time)
  }
  
  @objc
  func getSessionStatus(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    guard let session = AdioSession.session else {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_SESSION_EXISTS", "An audio session has not been created to get status from", error)
      return
    }

    resolve(session.status.rawValue)
  }
  
  func sessionDidGetDestroyed(_ session: Session) {
  }
  
  func sessionSeekTimeDidUpdate(_ session: Session) {
    if !hasListeners { return }
    sendEvent(withName: AdioSessionConstants.Events.SeekTimeUpdated, body: session.seekTime)
  }
  
  func sessionDidUpdateStatus(_ session: Session) {
    if !hasListeners { return }
    sendEvent(withName: AdioSessionConstants.Events.AudioSessionStatusUpdated, body: session.status.rawValue)
  }
  
  func sessionPlaybackTimeDidUpdate(_ session: Session, playTime time: Float) {
    if !hasListeners { return }
    sendEvent(withName: AdioSessionConstants.Events.PlaybackTimeUpdated, body: time)
  }
}
