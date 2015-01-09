//
//  TRGAudioConstants.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/7/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#ifndef TraceRoundGame_TRGAudioConstants_h
#define TraceRoundGame_TRGAudioConstants_h

const AudioComponentDescription kTRGAudioDescriptionTrace = {
    .componentType = kAudioUnitType_MusicDevice,
    .componentSubType = kAudioUnitSubType_Sampler,
    .componentManufacturer = kAudioUnitManufacturer_Apple,
    .componentFlags = 0,
    .componentFlagsMask = 0
};

const AudioComponentDescription kTRGAudioDescriptionDestroy = {
    .componentType = kAudioUnitType_MusicDevice,
    .componentSubType = kAudioUnitSubType_Sampler,
    .componentManufacturer = kAudioUnitManufacturer_Apple,
    .componentFlags = 0,
    .componentFlagsMask = 0
};

const AudioComponentDescription kTRGAudioDescriptionPitchEffect = {
    .componentType = kAudioUnitType_FormatConverter,
    .componentSubType = kAudioUnitSubType_NewTimePitch,
    .componentManufacturer = kAudioUnitManufacturer_Apple,
    .componentFlags = 0,
    .componentFlagsMask = 0};

const AudioComponentDescription kTRGAudioDescriptionMixer = {
    .componentType = kAudioUnitType_Mixer,
    .componentSubType = kAudioUnitSubType_MultiChannelMixer,
    .componentManufacturer = kAudioUnitManufacturer_Apple,
    .componentFlags = 0,
    .componentFlagsMask = 0
};

const AudioComponentDescription kTRGAudioDescriptionIO = {
    .componentType = kAudioUnitType_Output,
    .componentSubType = kAudioUnitSubType_RemoteIO,
    .componentManufacturer = kAudioUnitManufacturer_Apple,
    .componentFlags = 0,
    .componentFlagsMask = 0
};

#endif
