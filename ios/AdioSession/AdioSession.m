//
//  AdioSession.m
//  AdioNative
//
//  Created by Cole Voss on 2/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(AdioSession, RCTEventEmitter)

RCT_EXTERN_METHOD(createAudioSession:(NSString *) sessionId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(destroyAudioSession: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(addClip:(NSDictionary *) clipData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(addClips:(NSArray<NSDictionary *> *) clipsData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)



RCT_EXTERN_METHOD(play)
RCT_EXTERN_METHOD(stop)

RCT_EXTERN_METHOD(setSeekTime:(float *) seekTime
                  resolver:(RCTPromiseResolveBlock)
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getSeekTime: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getSessionStatus: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getPlaybackTime: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
