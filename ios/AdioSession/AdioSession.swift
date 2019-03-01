//
//  AdioSession.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

typealias ClipData = Dictionary<AnyHashable, Any>

struct AdioSessionConstants: Codable {
  struct Events: Codable {
    static let ClipDownloaded = "clipDownloaded"
    static let ClipDownloadProgress = "clipDownloadProgress"
    static let AudioSessionStatusUpdated = "audioSessionStatusUpdated"
    static let PlaybackTimeUpdated = "playbackTimeUpdated"
    static let SeekTimeUpdated = "seekTimeUpdated"
    static let AllClipsDownloadedUpdated = "allClipsDownloadedUpdated"
  }
}

@objc(AdioSession)
class AdioSession: RCTEventEmitter {
  static var session: Session?
  
  let downloadManager = DownloadManager()
  
  var hasListeners = false
  
  lazy var downloadSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override func supportedEvents() -> [String]! {
    return [
      AdioSessionConstants.Events.ClipDownloaded,
      AdioSessionConstants.Events.ClipDownloadProgress,
      AdioSessionConstants.Events.AudioSessionStatusUpdated,
      AdioSessionConstants.Events.PlaybackTimeUpdated,
      AdioSessionConstants.Events.SeekTimeUpdated,
      AdioSessionConstants.Events.AllClipsDownloadedUpdated
    ]
  }
  
  override func startObserving() {
    hasListeners = true
  }
  
  override func stopObserving() {
    hasListeners = false
  }
  
  @objc
  func createAudioSession(_ sessionId: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if AdioSession.session != nil && AdioSession.session?.id == sessionId {
      resolve(true)
      return
    }
    
    if AdioSession.session != nil && AdioSession.session?.id != sessionId {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_SESSION_EXISTS", "An audio session with a different id already exists. You need to destroy it before you can create another", error)
    }
    
    AdioSession.session = Session(id: sessionId, withDelegate: self)
    
    resolve(true)
  }
  
  @objc
  func destroyAudioSession(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    AdioSession.session = nil
    
    resolve(true)
  }
  
  func prepareClip(_ clip: SessionClip) {
    AdioSession.session?.addClip(clip)
    
    if !clip.isDownloaded {
      downloadClip(clip)
    }
  }
  
  @objc
  func addClip(_ clipData: ClipData, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if AdioSession.session == nil {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_NO_AUDIO_SESSION", "An audio session has not been created to add this clip to", error)
      return
    }
    
    let clip = SessionClip(clipData)
    
    prepareClip(clip!)
    
    resolve(true)
  }
  
  @objc
  func addClips(_ clipsData: [ClipData], resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if AdioSession.session == nil {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_NO_AUDIO_SESSION", "An audio session has not been created to add these clips to", error)
      return
    }
    
    for clipData in clipsData {
      let clip = SessionClip(clipData)
      
      prepareClip(clip!)
    }
    
    resolve(true)
  }
}
