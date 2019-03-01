//
//  DownloadManager.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class DownloadManager {
  var downloadSession: URLSession!
  var activeDownloads: [URL: DownloadContext] = [:]
  
  func startDownload(_ clip: SessionClip) {
    if activeDownloads[clip.src] != nil {
      activeDownloads[clip.src]?.clips.append(clip)
      
      return
    }
    
    let downloadContext = DownloadContext(clip)
    
    downloadContext.task = downloadSession.downloadTask(with: downloadContext.src)
    downloadContext.task!.resume()
    
    downloadContext.isDownloading = true
    
    activeDownloads[downloadContext.src] = downloadContext
  }
}
