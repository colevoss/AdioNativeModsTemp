//
//  AdioSession+URLSessionDelegate.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

extension AdioSession: URLSessionDownloadDelegate {
  func setDownloadSession() {
    if downloadManager.downloadSession == nil {
      downloadManager.downloadSession = downloadSession
    }
  }
  
  func downloadClip(_ clip: SessionClip) {
    setDownloadSession()
    
    downloadManager.startDownload(clip)
  }
  
  // Clip Downloaded
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    guard let src = downloadTask.originalRequest?.url else { return }
    guard let downloadContext = downloadManager.activeDownloads.removeValue(forKey: src) else { return }
    
    let destinationURL = downloadContext.clips[0].localSrc
    let fileManager = FileManager.default
    
    try? fileManager.removeItem(at: destinationURL!)
    
    do {
      try fileManager.moveItem(at: location, to: destinationURL!)
      
      for clip in downloadContext.clips {
        clip.setIsDownloaded()
        
        AdioSession.session?.addClip(clip)
        
        if !hasListeners { continue }
        
        sendEvent(withName: AdioSessionConstants.Events.ClipDownloaded, body: clip.data())
      }
      
    } catch {
      Logger.error(error)
    }
  }
  
  // Clip download progress
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    guard let src = downloadTask.originalRequest?.url else { return }
    
    let downloadContext = downloadManager.activeDownloads[src]
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    
    downloadContext?.progress = progress
    
    if !hasListeners { return }
    
    let clips = downloadContext?.clips
    
    for clip in clips! {
      sendEvent(withName: AdioSessionConstants.Events.ClipDownloadProgress, body: [
        "id": clip.id,
        "progress": progress])
    }
  }
}
