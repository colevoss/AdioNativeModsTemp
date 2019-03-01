//
//  Logger.swift
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

var name: String = "ADIO-LOG"

class Logger {
  
  static func debug(_ message: Any...) {
    print("[\(name) DEBUG] ", message)
  }
  
  static func error(_ error: Error) {
    print("[\(name) ERROR] " + error.localizedDescription)
  }
}
