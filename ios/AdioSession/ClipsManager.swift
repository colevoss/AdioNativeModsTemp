//
//  ClipsManager.swift
//  AdioNativeMods
//
//  Created by Cole Voss on 2/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

struct ClipsManager {
  typealias ClipsCollection = [String: SessionClip]
  
  private var clips: ClipsCollection = [:]
  
  init(_ clips: ClipsCollection = [:]) {
    self.clips = clips
  }
}

extension ClipsManager : Collection {
  typealias Index = ClipsCollection.Index
  typealias Element = ClipsCollection.Element
  
  var startIndex: Index { return clips.startIndex }
  var endIndex: Index { return clips.endIndex }
  
  subscript(id: Index) -> Element {
    get {
      return clips[id]
    }
  }
  
  func index(after i: Index) -> Index {
    return clips.index(after: i)
  }
  
  mutating func addClip(_ clip: SessionClip) {
    self.clips[clip.id] = clip
  }
  
  mutating func removeClip(_ id: String) -> SessionClip? {
    return self.clips.removeValue(forKey: id)
  }
  
  mutating func removeClip(_ clip: SessionClip) -> SessionClip? {
    return self.removeClip(clip.id)
  }
}

extension ClipsManager {
  func prepare(atTime time: Float) {
    for (_, clip) in self.clips where clip.isSchedulable && clip.shouldPlay(atTime: time) {
      clip.prepare(withOffset: time)
    }
  }
  
  func play(atTime time: Float, withAnchor anchor: AVAudioFramePosition) {
    for (_, clip) in self.clips where clip.isPlayable && clip.shouldPlay(atTime: time) {
      clip.play(atTime: time, withAnchor: anchor)
    }
  }
  
  func stop() {
    for (_, clip) in self.clips where clip.isPlaying {
      clip.stop()
    }
  }
}
