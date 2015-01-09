//
//  TRGMidiConstants.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/7/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#ifndef TraceRoundGame_TRGMidiConstants_h
#define TraceRoundGame_TRGMidiConstants_h

// define some midi notes to play - middle C (60), C one octave below (48) and C one octave above (72)
#define kLowNote  48
#define kMidNote  60
#define kHighNote 72

const Byte kMIDIZeroByte             = 0x00;
const Byte kMIDIStatusChannelMask    = 0x0F;
const Byte kMIDIStatusCommandMask = 0xF0;

static BOOL isSystemMidiStatus(Byte midiStatusByte) {
    return ((midiStatusByte & kMIDIStatusCommandMask) == kMIDIStatusCommandMask);
}

static Byte midiCommandFromStatus(Byte midiStatusByte) {
    return midiStatusByte >> 4;
}

static Byte midiChannelFromStatus(Byte midiStatusByte) {
    return midiStatusByte & kMIDIStatusChannelMask;
}

static Byte midiStatusCreate(Byte midiCommand, Byte midiChannel) {
    return (midiCommand << 4 | 0) | (midiChannel | kMIDIStatusChannelMask);
}

//static CFStringRef midiNoteLabelFor


/*
 * Channel Voice Messages [nnnn = 0->15 =  0x00->0x0F] (Channels 1-16)
 */

/* Note Released (ended) */                 //   command channel       note (0-127)            velocity (0-127)
const Byte kMIDINoteOffEvent    = 0x08;     // [ 1000    nnnn    ] | [ 0kkkkkkk     ]      | [ 0vvvvvvv         ]

/* Note Depressed (started) */              //   command channel       note (0-127)            velocity (0-127)
const Byte kMIDINoteOnEvent     = 0x09;     // [ 1001    nnnn    ] | [ 0kkkkkkk     ]      | [ 0vvvvvvv         ]

/* Polyphonic Key Pressure (aftertouch) */  //   command channel ]     note (0-127)            pressure (0-127)
const Byte kMIDIPolyphonicAT    = 0x0A;     // [ 1010    nnnn    ] | [ 0kkkkkkk     ]      | [ 0vvvvvvv         ]

/* Control Change (pedals, levers, etc) */  //   command channel ]     ctrlr (0-119)           ctrl val (0-127)
const Byte kMIDIControlChange   = 0x0B;     // [ 1011    nnnn    ] | [ 0ccccccc     ]      | [ 0vvvvvvv         ]

/* Program Change (patch # changes) */      //   command channel ]     program # (0-127)
const Byte kMIDIProgramChange   = 0x0C;     // [ 1100    nnnn    ] | [ 0ppppppp          ]

/* Channel Pressure */                      //   command channel ]     pressure # (0-127)
const Byte kMIDIChannelPressure = 0x0D;     // [ 1101    nnnn    ] | [ 0vvvvvvv          ]

/* Control Change (pedals, levers, etc) */  //   command channel ]     LSB (0-119)           MSB (0-127)
const Byte kMIDIPitchBendChange = 0x0E;     // [ 1110    nnnn    ] | [ 0lllllll        ] | [ 0mmmmmmm           ]
// Center = 0x2000 = no pitch change

/*
 * Channel Mode Messages (see kMIDIControlChange) 
 *  reserved controller numbers 120-127 for special messages
 */

/* All Oscillators Turn Off, Volume Envelopes -> 0 ASAP */
const Byte kMIDIControlAllSoundOff   = 0x78; // c = 120

/* All Controller Values Reset to Defaults */
const Byte kMIDIControlResetAll      = 0x79; // c = 121

/* Local Off (v=0): All Devices on Ch. Respond Only to Data Received Over MIDI (Played data, etc. ignored) */
/* Local On  (v=127): Restores Functions of Normal Controllers  */
const Byte kMIDIControlLocal         = 0x7A; // c = 122

/* All Oscillators Will Turn Off.  Note: All Messages Cause All Notes Off. */
const Byte kMIDIControlAllNotesOff   = 0x7B; // c = 123, v = 0: All Notes Off
const Byte kMIDIControlOmniModeOff   = 0x7C; // c = 124, v = 0; Omni Mode Off
const Byte kMIDIControlOmniModeOn    = 0x7D; // c = 125, v = 0; Omni Mode On
const Byte kMIDIControlMonoModeOn    = 0x7E; // c = 126, v = M; Mono Mode On (Poly Off) M = #channels (Omni Off) or 0 (Omni On)
const Byte kMIDIControlPolyModeOn    = 0x7F; // c = 127, v = 0; Poly Mode On (Mono Off)

/*
 * System Common Messages
 */

/* Allows Manufacturers to Create Own Messages (bulk dumps, patch parms, other non-spec data) */
/* Provides Mechanism for Creating Additional MIDI Specification Messages */

// Manufacturer's ID Code (assigned by MMA or AMEI)
//  either 1 byte (0iiiiiii) or 3 bytes (0iiiiiiii 0iiiiiiii 0iiiiiiii)
//  2 of the 1-byte IDs are reserved for extensions called Universal Exclusive Messages
//   which are not manufacturer-specific.
// If a device recognizes the ID code as its own (or as a supported Universal message)
//  it will listen to the rest of the message (0ddddddd).
// Otherwise, message will be ignored.
// Note: Real-Time messages ONLY may be interleaved w/System Exclusive)
const Byte kMIDISystemExclusive      = 0xF0; // 1st Byte
                                                    // 2nd Byte (0iiiiiii) manufacturer ID
                                                    // -- DATA START--
                                                    // 3rd Byte (0iiiiiii) optional device ID (distinguish if > 1 of same type device in daisy-chain)
                                                    // 4th Byte (0iiiiiii) optional model ID
                                                    // ...
                                                    // Nth-1 Byte (0sssssss) optional checksum (check integrity of message)
                                                    // -- DATA END --
const Byte kMIDISystemExclusiveEnd  = 0xF7; // Nth Byte (indicates SysEx message finished)

/* MIDI Time Code Quarter Frame */
const Byte kMIDISystemTimeCodeQuarterFrame= 0xF1; // [ 0nnndddd ] n = Message Type, d = Values

/* Song Position Pointer */
const Byte kMIDISystemSongPosition = 0xF2;        // Internal 14bit Register (Holds # of MIDI beats)
                                            //  1 beat = six MIDI clocks since song start
                                            // [ 0lllllll ] | [0mmmmmmm], l = LSB, m = MSB

/* Song Select */
const Byte kMIDISystemSongSelect = 0xF3;          // [ 0sssssss ], s = Sequence or Song to be Played

/* Tune Request */
const Byte kMIDISystemTuneRequest = 0xF6;         // All Analog Synthesizers Should Tune Oscillators

/*
 * System Real-Time Messages
 */

/* Timing Clock */
const Byte kMIDISystemTimingClock = 0xF8;         // Send 24 Times Per Quarter Note When Synchronization Req'd.

/* Start */
const Byte kMIDISystemStart = 0xFA;               // Start current sequence playing (message will be followed w/timing clocks)

/* Continue */
const Byte kMIDISystemContinue = 0xFB;            // Continue at the point the sequence was stopped.

/* Stop */
const Byte kMIDISystemStop = 0xFC;                // Stop the current sequence.

/* Active Sensing */
const Byte kMIDISystemActiveSensing = 0xFE;       // Intended to be sent repeatedly.  Tells receiver connection is alive.
                                            // Use is optional.  When received initially, expects to receive another
                                            // active sensing message each 300ms (max); if not, assumes connection
                                            // terminated.  At termination, the receiver will turn off all voices
                                            // and return ot normal (non-active sensing) operation.

/* Reset */
const Byte kMIDISystemReset = 0xFF;               // Reset all receivers in the system to power-up status.
                                            // Should be used sparingly, preferably under manual control.
                                            // In particular, should NOT be sent on power-up.

#endif
