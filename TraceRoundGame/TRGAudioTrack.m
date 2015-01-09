//
//  TRGAudioTrack.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/8/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGAudioTrack.h"

@implementation TRGAudioTrack

//- (OSStatus)attachAudioUnitToNode:(AUNode)node inGraph:(AUGraph)graph {
//    // Obtain Proper Reference to Audio Unit From Node in Graph
//    OSStatus result = noErr;
//    result = AUGraphNodeInfo(graph, node, NULL, &_unit);
//    NSError * error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
//    if (result != noErr) NSLog (@"Unable to obtain a reference to the audio unit. Error: %@", error);
//    return result;
//}
//
//- (OSStatus)setAudioUnitProperty:(AudioUnitPropertyID)propertyID inScope:(AudioUnitScope)inScope inElement:(AudioUnitElement)inElement inData:(const void *)inData inDataSize:(UInt32)inDataSize {
//    OSStatus result = noErr;
//    result = AudioUnitSetProperty(_unit, propertyID, inScope, inElement, inData, inDataSize);
//    NSError * error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
//    if (result != noErr) NSLog(@"AudioUnitSetProperty unable to set AudioUnitPropertyID.  Error: %@", error);
//    return result;
//}

- (void)mute {
    self.isMuted = YES;
}
- (void)unmute {
    self.isMuted = NO;
}
- (void)toggleMute {
    self.isMuted = !self.isMuted;
}
@end
