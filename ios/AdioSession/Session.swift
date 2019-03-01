//
//  Session.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

enum SessionStatus: String {
  case Initialized, Ready, Playing, Busy, Destroyed
}

protocol SessionProtocol {
  var engine: AVAudioEngine { get }
  var mixer: AVAudioMixerNode { get }
  var status: SessionStatus { get set }
  var clips: ClipsManager { get set }
  var seekTime: Float { get set }
  var offsetTime: AVAudioTime? { get set }
  var isPlaying: Bool { get set }
  var id: String { get set }
}

protocol SessionDelegate: AnyObject {
  func sessionDidUpdateStatus(_ session: Session)
  func sessionDidGetDestroyed(_ session: Session)
  func sessionSeekTimeDidUpdate(_ session: Session)
  func sessionPlaybackTimeDidUpdate(_ session: Session, playTime time: Float)
}

class Session: SessionProtocol {
  weak var delegate: SessionDelegate?
  
  var engine = AVAudioEngine()
  var mixer = AVAudioMixerNode()
  var status = SessionStatus.Initialized
  var clips: ClipsManager = ClipsManager()
  var offsetTime: AVAudioTime?
  var isPlaying: Bool = false
  var updater: CADisplayLink?
  var id: String
  
  var seekTime: Float = 0
  
  var duration: Float {
    return clips.map({ $0.value.endTime }).max() ?? 0
  }
  
  var currentTime: Float {
    guard let offsetTime = offsetTime else { return 0 }
    guard let nowTime = engine.outputNode.lastRenderTime else { return 0 }
    
    let offsetSeconds = Float(offsetTime.sampleTime) / Float(offsetTime.sampleRate)
    let nowSeconds = Float(nowTime.sampleTime) / Float(nowTime.sampleRate)
    
    return nowSeconds - offsetSeconds
  }
  
  
  init?(id: String, withDelegate delegate: SessionDelegate? = nil) {
    self.id = id
    self.delegate = delegate
    
    // Set up basic engine nodes
    engine.attach(mixer)
    engine.connect(mixer, to: engine.outputNode, format: nil)
    
    updater = CADisplayLink(target: self, selector: #selector(updatePlaybackTime))
    updater?.add(to: .main, forMode: .default)
    updater?.isPaused = true
    
    do {
      try engine.start()
      updateStatus(.Ready)
    } catch {
      return
    }
  }
  
  deinit {
    stopClips()
    engine.stop()
    delegate?.sessionDidGetDestroyed(self)
  }
  
  @objc
  private func updatePlaybackTime() {
    delegate?.sessionPlaybackTimeDidUpdate(self, playTime: currentTime + seekTime)
  }
  
  func updateStatus(_ status: SessionStatus) {
    self.status = status
    
    delegate?.sessionDidUpdateStatus(self)
  }
  
  func addClip(_ clip: SessionClip) {
    clips.addClip(clip)
    
    if !clip.isDownloaded! { return }
    
    addClipToGraph(clip)
    clip.prepare(withOffset: seekTime)
  }
  
  private func prepareAllClips() {
    updateStatus(.Busy)
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.clips.prepare(atTime: self.seekTime)
      
      self.updateStatus(.Ready)
    }
  }
  
  private func addClipToGraph(_ clip: SessionClip) {
    engine.attach(clip.playerNode)
    engine.connect(clip.playerNode, to: mixer, format: nil)
  }
  
  func setSeekTime(_ seekTime: Float) {
    self.seekTime = seekTime
    
    delegate?.sessionSeekTimeDidUpdate(self)
    
    if status == .Playing {
      updater?.isPaused = true
      
      stopClips { [ weak self] in
        guard let self = self else { return }
        
        self.prepareAllClips()
        
        return
      }
    }
    
    prepareAllClips()
  }
  
  private func stopClips(completionHandler: (() -> Void)? = nil) {
    DispatchQueue.global(qos: .userInitiated).async {
      self.clips.stop()
      
      guard let completionHandler = completionHandler else { return }
      
      completionHandler()
    }
  }
  
  
  func stop() {
    updateStatus(.Busy)
    updater?.isPaused = true
    
    let newSeekTime = seekTime + currentTime
    
    stopClips { [weak self] in
      guard let self = self else { return }
      
      self.setSeekTime(newSeekTime)
    }
  }
  
  
  func play() {
    if !engine.isRunning {
      do {
        try engine.start()
      } catch {
        Logger.error(error)
      }
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.offsetTime = self.engine.outputNode.lastRenderTime

      self.clips.play(atTime: self.seekTime, withAnchor: (self.offsetTime?.sampleTime)!)
      
      self.updater?.isPaused = false
      self.updateStatus(.Playing)
    }
  }
}
