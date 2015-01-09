//
//  TRGAudioController.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/6/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TRGAudioController : NSObject

// Set of AudioUnit Objects
@property (readwrite) AudioUnit audioUnitTrace;
@property (readwrite) BOOL isMutedTrace;

@property (readwrite) AudioUnit audioUnitDestroy;
@property (readwrite) BOOL isMutedDestroy;


- (void) setupAudio;
- (int) pitchAdj: (int) pitchValue;

- (void)startDestruction;
- (void)stopDestruction;



@end
