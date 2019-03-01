//
//  SessionClip.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

class SessionClip {
  var id: String
  var startTime: Float!
  var src: URL!
  var localSrc: URL!
  var isDownloaded: Bool!
  var audioFile: AVAudioFile?
  var needsScheduled = true
  var isPlaying = false
  var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
  
  var format: AVAudioFormat? {
    guard let audioFile = audioFile else { return nil }
    
    return audioFile.fileFormat
  }
  
  var sampleRate: Float {
    return Float(format?.sampleRate ?? 44100)
  }
  
  var lengthSamples: AVAudioFramePosition {
    return audioFile?.length ?? 0
  }
  
  var lengthSeconds: Float {
    return Float(lengthSamples) / sampleRate
  }
  
  var endTime: Float {
    return lengthSeconds + startTime
  }
  
  var isSchedulable: Bool {
    return isDownloaded && needsScheduled
  }
  
  var isPlayable: Bool {
    return isDownloaded && !needsScheduled
  }
  
  init?(_ clipData: ClipData) {
    guard let id = clipData["id"] as? String else { return nil }
    guard let src = clipData["src"] as? String else { return nil }
    guard let startTime = clipData["startTimeMs"] as? Float else { return nil }
    
    self.id = id
    self.src = URL(string: src)
    self.startTime = startTime / 1000
    
    setLocalSrc()
    setIsDownloaded()
  }
  
  // Determines where on the device the file is or should be stored based on its remote source
  func setLocalSrc() {
    let documentDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    let destinationURL = documentDirectoryURL.appendingPathComponent(src.lastPathComponent)
    
    localSrc = destinationURL
  }
  
  
  func setIsDownloaded() {
    isDownloaded = FileManager.default.fileExists(atPath: localSrc.path)
    
    if !isDownloaded { return }
    
    setupAudioFile()
  }
  
  func setupAudioFile() {
    if audioFile != nil { return }
    
    do {
      audioFile = try AVAudioFile(forReading: localSrc)
    } catch {
      Logger.error(error)
    }
  }
  
  func shouldPlay(atTime offset: Float) -> Bool {
    return endTime > offset
  }
  
  func startFrame(atTime offset: Float) -> AVAudioFramePosition {
    let start = max(offset - startTime, 0)
    
    return AVAudioFramePosition(start * sampleRate)
  }
  
  func frameCount(atTime offset: Float) -> AVAudioFrameCount {
    let start = startFrame(atTime: offset)
    
    return AVAudioFrameCount(lengthSamples - start)
  }
  
  func stop() {
    playerNode.stop()
    
    needsScheduled = true
    isPlaying = false
  }
  
  func prepare(withOffset offset: Float) {
    guard let audioFile = audioFile else { return }
        
    stop()
    
    if !shouldPlay(atTime: offset) || !needsScheduled { return }
    
    playerNode.scheduleSegment(audioFile, startingFrame: startFrame(atTime: offset), frameCount: frameCount(atTime: offset), at: nil) {
      self.needsScheduled = true
    }
    
    needsScheduled = false
  }
  
  func play(atTime offset: Float, withAnchor anchor: AVAudioFramePosition) {
    if !shouldPlay(atTime: offset) { return }
    
    let playAt = Float(anchor) + max(startTime - offset, 0) * sampleRate
    let audioTime = AVAudioTime(sampleTime: AVAudioFramePosition(Double(playAt)), atRate: Double(sampleRate))
    
    playerNode.play(at: audioTime)
    
    isPlaying = true
  }
  
  func data() -> Dictionary<String, Any> {
    return [
      "id": self.id,
      "src": self.src!.absoluteString,
      "localSrc": self.localSrc!.absoluteString,
      "isDownloaded": self.isDownloaded
    ]
  }
}
