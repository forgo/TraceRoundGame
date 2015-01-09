//
//  TRGAudioController.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/6/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGAudioController.h"
#import "TRGAudioConstants.h"
#import "TRGMidiConstants.h"

@interface TRGAudioController ()

@property (readwrite) AUGraph graph;
@property (readwrite) Float64 sampleRate;

@property (readwrite) AudioUnit audioUnitPitchEffect;
@property (readwrite) AudioUnit audioUnitMixer;
@property (readwrite) AudioUnit audioUnitIO;


@end

@implementation TRGAudioController


const int nNotes = 18;
const Byte notes[nNotes] = { 55, 50, 55, 50, 55, 50, 55, 59, 62, 60, 57, 60, 57, 60, 57, 54, 57, 50 };
static int currentNoteIndex = 0;

#pragma mark - Audio Controls

// Start the note play
- (void)startDestruction {
    
    
    
    Byte note = notes[currentNoteIndex];
    
    Byte noteVelocity = 127;
    Byte noteChannel = 0;
    Byte noteCommand = midiStatusCreate(kMIDINoteOnEvent, noteChannel);
    
    OSStatus result = noErr;
	if(!self.isMutedDestroy) {
        result = MusicDeviceMIDIEvent(self.audioUnitDestroy, noteCommand, note, noteVelocity, 0);
    }
    if (result != noErr) NSLog (@"Unable to start playing the note on 'destroy' audio unit. Error code: %d\n", (int) result);
}

// Stop the note play
- (void)stopDestruction {
    
    Byte note = notes[currentNoteIndex];

    currentNoteIndex = (currentNoteIndex + 1) % nNotes;
    
    Byte noteChannel = 0;
    Byte noteCommand = midiStatusCreate(kMIDINoteOffEvent, noteChannel);
    
    OSStatus result = noErr;
	if(!self.isMutedDestroy){
        result = MusicDeviceMIDIEvent(self.audioUnitDestroy, noteCommand, note, 0, 0);
    }
    if (result != noErr) NSLog (@"Unable to stop playing the note on 'destroy'. Error code: %d\n", (int) result);
}

- (void)pitchAdjustmentChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int pitchAdj = (int)roundf(slider.value);
    if (abs(pitchAdj) <= 5 ) {
        pitchAdj = 0;
    }
    NSLog(@"Pitch adjustment value = %d", pitchAdj);
//    _pitchAdjustmentValue.text = [NSString stringWithFormat:@"%d", pitchAdj];
    int result = [self pitchAdj:pitchAdj];
    
    if(result != 0) NSLog (@"Unable to set the property pitch adjustment parameter on the effects unit. Error code: %d\n", (int) result);
}

//////////


- (void) setupAudio {
    // Set up the audio session for this app, in the process obtaining the
    // hardware sample rate for use in the audio processing graph.
    BOOL audioSessionActivated = [self setupAudioSession];
    NSAssert (audioSessionActivated == YES, @"Unable to set up audio session.");
    
    // Create the audio processing graph; place references to the graph and to the Sampler unit
    // into the processingGraph and samplerUnit instance variables.
    [self createAUGraph];
    [self configureAndStartAudioProcessingGraph: self.graph];
    
    [self loadSoundFonts];
    
    self.isMutedTrace = NO;
    self.isMutedDestroy = NO;
}

- (int) pitchAdj:(int)pitchValue {
    OSStatus result = AudioUnitSetParameter (
                                             _audioUnitPitchEffect,
                                             kNewTimePitchParam_Pitch,
                                             kAudioUnitScope_Global,
                                             0,
                                             pitchValue,
                                             0
                                             );
    return (int) result;
}


-(BOOL)setupAudioSession {
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    // Assign Category to Audio Session
    // Playback Category Supports Audio Output with Ring/Silent in Silent Position
    NSError * audioSessionError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError];
    if (audioSessionError != nil) {
        NSLog(@"Error setting audio session category: %@", [audioSessionError localizedDescription]);
        return NO;
    }
    // Desired Hardware Sample Rate
    self.sampleRate = 44100.0;  // [Hz]
    [audioSession setActive:YES error:&audioSessionError];
    if (audioSessionError != nil) {
        NSLog(@"Error activating audio session: %@", [audioSessionError localizedDescription]);
        return NO;
    }
    return YES;
}



#pragma mark - Audio Setup
-(BOOL)createAUGraph {
    
    OSStatus result = noErr;
    AUNode nodeTrace, nodeDestroy, nodePitchEffect, nodeMixer, nodeIO;

    // Instantiate an Audio Processing Graph
    result = NewAUGraph(&_graph);
    if (result != noErr) NSLog(@"Unable to create an AUGraph object. Error code: %d", (int)result);
    
    // Add Graph Nodes
    [self addNode:&nodeTrace         toGraph:self.graph withDescription:kTRGAudioDescriptionTrace];
    [self addNode:&nodeDestroy       toGraph:self.graph withDescription:kTRGAudioDescriptionDestroy];
    [self addNode:&nodePitchEffect   toGraph:self.graph withDescription:kTRGAudioDescriptionPitchEffect];
    [self addNode:&nodeMixer         toGraph:self.graph withDescription:kTRGAudioDescriptionMixer];
    [self addNode:&nodeIO            toGraph:self.graph withDescription:kTRGAudioDescriptionIO];
    
    // Open The Graph
    result = AUGraphOpen(self.graph);
    if (result != noErr) NSLog(@"Unable to open the audio processing graph. Error code: %d", (int)result);
    
    // Obtain Mixer Unit Instance From Its Corresponding Node
    [self attachAudioUnit:&_audioUnitMixer toNode:nodeMixer];
    
    // Multichannel Mixer Unit Setup
    UInt32 mixerChannelCount   = 2;
    NSLog (@"Setting mixer unit input channel count to: %u", (unsigned int)mixerChannelCount);
    [self setAudioUnit:_audioUnitMixer property:kAudioUnitProperty_ElementCount inScope:kAudioUnitScope_Input inElement:0 inData:&mixerChannelCount inDataSize:sizeof(mixerChannelCount)];
    
    [self connectSourceNode:nodeTrace       onOutputChannel:0 toDestinationNode:nodeMixer       onInputChannel:0];
    [self connectSourceNode:nodeDestroy     onOutputChannel:0 toDestinationNode:nodePitchEffect onInputChannel:0];
    [self connectSourceNode:nodePitchEffect onOutputChannel:0 toDestinationNode:nodeMixer       onInputChannel:1];
    [self connectSourceNode:nodeMixer       onOutputChannel:0 toDestinationNode:nodeIO          onInputChannel:0];
    
    // Obtain references to all of the audio units from their nodes
    [self attachAudioUnit:&_audioUnitTrace          toNode:nodeTrace];
    [self attachAudioUnit:&_audioUnitDestroy        toNode:nodeDestroy];
    [self attachAudioUnit:&_audioUnitPitchEffect    toNode:nodePitchEffect];
    [self attachAudioUnit:&_audioUnitIO             toNode:nodeIO];
    
    return YES;
}

- (OSStatus)connectSourceNode:(AUNode)sourceNode onOutputChannel:(UInt32)outputChannel toDestinationNode:(AUNode)destinationNode onInputChannel:(UInt32)inputChannel {
    OSStatus result = noErr;
    result = AUGraphConnectNodeInput(self.graph, sourceNode, outputChannel, destinationNode, inputChannel);
    NSError * error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
    if (result != noErr) NSLog (@"Unable to connect source node on ouput channel %d to destination node on input channel %d in the audio processing graph. Error: %@", (unsigned int)outputChannel, (unsigned int)inputChannel, error);
    return result;
}

- (OSStatus)addNode:(AUNode *)node toGraph:(AUGraph)graph withDescription:(AudioComponentDescription)description {
    OSStatus result = noErr;
    result = AUGraphAddNode(graph, &description, node);
    NSError * error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
    if (result != noErr) NSLog(@"Unable to add node to audio graph. Error: %@", error);
    return result;
}

- (OSStatus)attachAudioUnit:(AudioUnit *)audioUnit toNode:(AUNode)node {
    // Obtain Proper Reference to Audio Unit From Node in Graph
    OSStatus result = noErr;
    result = AUGraphNodeInfo(self.graph, node, NULL, audioUnit);
    NSError * error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
    if (result != noErr) NSLog (@"Unable to obtain a reference to the audio unit. Error: %@", error);
    return result;
}

- (OSStatus)setAudioUnit:(AudioUnit)audioUnit property:(AudioUnitPropertyID)propertyID inScope:(AudioUnitScope)inScope inElement:(AudioUnitElement)inElement inData:(const void *)inData inDataSize:(UInt32)inDataSize {
    OSStatus result = noErr;
    result = AudioUnitSetProperty(audioUnit, propertyID, inScope, inElement, inData, inDataSize);
    NSError * error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
    if (result != noErr) NSLog(@"AudioUnitSetProperty unable to set AudioUnitPropertyID.  Error: %@", error);
    return result;
}

// With an instantiated audio processing graph, configure audio units, initialize it, and start it.
- (void)configureAndStartAudioProcessingGraph:(AUGraph)graph {
    
    OSStatus result = noErr;
    UInt32 framesPerSlice = 0;
    UInt32 framesPerSlicePropertySize = sizeof(framesPerSlice);
    UInt32 sampleRatePropertySize = sizeof(self.sampleRate);
    
    result = AudioUnitInitialize (self.audioUnitIO);
    if (result != noErr) NSLog (@"Unable to initialize the I/O audio unit. Error code: %d", (int) result);
    
    // Set the I/O audio unit's output sample rate.
    result = AudioUnitSetProperty(self.audioUnitIO, kAudioUnitProperty_SampleRate, kAudioUnitScope_Output, 0, &_sampleRate, sampleRatePropertySize);
    if (result != noErr) NSLog (@"AudioUnitSetProperty (Unable to set I/O audio unit output stream sample rate). Error code: %d", (int) result);
    
    // Obtain the value of the maximum-frames-per-slice from the I/O unit.
    result = AudioUnitGetProperty(self.audioUnitIO, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &framesPerSlice, &framesPerSlicePropertySize);
    if (result != noErr) NSLog (@"Unable to retrieve the maximum frames per slice property from the I/O audio unit. Error code: %d", (int) result);
    
    // Set the 'Trace' Audio Unit's Output Sample Rate
    [self setAudioUnit:self.audioUnitTrace property:kAudioUnitProperty_SampleRate inScope:kAudioUnitScope_Output inElement:0 inData:&_sampleRate inDataSize:sampleRatePropertySize];
    
    // Set the 'Trace' Audio Unit's Maximum Frames-Per-Slice.
    [self setAudioUnit:self.audioUnitTrace property:kAudioUnitProperty_MaximumFramesPerSlice inScope:kAudioUnitScope_Global inElement:0 inData:&framesPerSlice inDataSize:framesPerSlicePropertySize];
    
    // Set the 'Destroy' Audio Unit's Output Sample Rate
    [self setAudioUnit:self.audioUnitDestroy property:kAudioUnitProperty_SampleRate inScope:kAudioUnitScope_Output inElement:0 inData:&_sampleRate inDataSize:sampleRatePropertySize];
    
    // Set the 'Destroy' Audio Unit's Maximum Frames-Per-Slice.
    [self setAudioUnit:self.audioUnitDestroy property:kAudioUnitProperty_MaximumFramesPerSlice inScope:kAudioUnitScope_Global inElement:0 inData:&framesPerSlice inDataSize:framesPerSlicePropertySize];
    
    if (graph) {
        
        // Initialize the audio processing graph.
        result = AUGraphInitialize(graph);
        if (result != noErr) NSLog (@"Unable to initialze AUGraph object. Error code: %d", (int) result);
        
        // Start the graph
        result = AUGraphStart(graph);
        if (result != noErr) NSLog (@"Unable to start audio processing graph. Error code: %d", (int) result);
        
        // Print out the graph to the console
        CAShow(graph);
    }
}

- (void) loadSoundFonts {
    
    NSURL * soundFontURL = [[NSBundle mainBundle] URLForResource:@"gorts_filters" withExtension:@"sf2"];
	if (soundFontURL)   NSLog(@"Attempting to load sound font '%@'\n", [soundFontURL description]);
	else                NSLog(@"Could not get sound font path!");
    
    // Bank Preset Data Structure
    AUSamplerBankPresetData instrumentData;
    instrumentData.bankURL  = (__bridge CFURLRef)soundFontURL;
    instrumentData.bankMSB  = kAUSampler_DefaultMelodicBankMSB;

    // Load 'Trace' Sound Font Instrument from Preset
    instrumentData.bankLSB  = kAUSampler_DefaultBankLSB;
    instrumentData.presetID = (UInt8) 94;
    [self setAudioUnit:self.audioUnitTrace property:kAUSamplerProperty_LoadPresetFromBank inScope:kAudioUnitScope_Global inElement:0 inData:&instrumentData inDataSize:sizeof(instrumentData)];
    
    // Load 'Destroy' Sound Font Instrument from Preset
    instrumentData.bankLSB  = kAUSampler_DefaultBankLSB;
    instrumentData.presetID = (UInt8) 95;
    [self setAudioUnit:self.audioUnitDestroy property:kAUSamplerProperty_LoadPresetFromBank inScope:kAudioUnitScope_Global inElement:0 inData:&instrumentData inDataSize:sizeof(instrumentData)];
}

@end
