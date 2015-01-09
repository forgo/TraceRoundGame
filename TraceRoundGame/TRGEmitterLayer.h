//
//  TRGEmitterLayer.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface TRGEmitterLayer : CAEmitterLayer

@property (nonatomic, strong) CAEmitterCell * cell;

+ (instancetype)sharedBubbles;
+ (instancetype)sharedFire;
+ (instancetype)fire;
+ (instancetype)sharedSmoke;

@end
