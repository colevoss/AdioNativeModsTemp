//
//  DownloadContext.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class DownloadContext {
  var clips = [SessionClip]()
  var src: URL
  
  var task: URLSessionDownloadTask?
  var isDownloading = false
  var progress: Float = 0
  
  init(_ clip: SessionClip) {
    self.src = clip.src
    self.clips.append(clip)
  }
}
