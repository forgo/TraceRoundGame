//
//  TRGAudioTrack.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/8/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TRGAudioTrack : NSObject

//@property (readwrite) AudioUnit unit;
@property (readwrite) BOOL isMuted;

//- (OSStatus)attachAudioUnitToNode:(AUNode)node inGraph:(AUGraph)graph;
//- (OSStatus)setAudioUnitProperty:(AudioUnitPropertyID)propertyID inScope:(AudioUnitScope)inScope inElement:(AudioUnitElement)inElement inData:(const void *)inData inDataSize:(UInt32)inDataSize;

- (void)mute;
- (void)unmute;
- (void)toggleMute;

@end
