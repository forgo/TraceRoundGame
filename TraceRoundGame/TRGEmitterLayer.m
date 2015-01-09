//
//  TRGEmitterLayer.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGEmitterLayer.h"
#import "TRGColors.h"

@implementation TRGEmitterLayer

- (id)init
{
    self = [super init];
    if (self) {
        // Effectively Turn OFF Emitting Particles Initially
        // Default Position of Emitter Cell is (0,0,0)
        // Let's Wait to Brings these Bad Boys to Life
        self.lifetime = 0;
    }
    return self;
}

+ (instancetype)sharedBubbles
{
    static dispatch_once_t once;
    static id sharedBubbles;
    dispatch_once(&once, ^{
        sharedBubbles = [TRGEmitterLayer layer];
        [sharedBubbles configureBubbles];
    });
    return sharedBubbles;
}

+ (instancetype)sharedFire
{
    static dispatch_once_t once;
    static id sharedFire;
    dispatch_once(&once, ^{
        sharedFire = [TRGEmitterLayer layer];
        [sharedFire configureFire];
    });
    return sharedFire;
}

+ (instancetype)fire
{
    TRGEmitterLayer * fire = [TRGEmitterLayer layer];
    [fire configureFire];
    return fire;
}

+ (instancetype)sharedSmoke
{
    static dispatch_once_t once;
    static id sharedSmoke;
    dispatch_once(&once, ^{
        sharedSmoke = [TRGEmitterLayer layer];
        [sharedSmoke configureSmoke];
    });
    return sharedSmoke;
}

- (void)configureBubbles
{
    self.emitterZPosition = 10;
    self.cell = [CAEmitterCell emitterCell];
    self.cell.scale = 0.05;
    self.cell.scaleRange = 0.5;
    self.cell.emissionRange = (CGFloat)M_PI_2;
    self.cell.lifetime = 0.6;
    self.cell.lifetimeRange = 0.1;
    self.cell.birthRate = 150;
    self.cell.velocity = 20;
    self.cell.velocityRange = 5;
    self.cell.yAcceleration = 0;
    self.cell.spin = 1.1;
    self.cell.spinRange = 0.1;
    self.cell.contents = (id)[[UIImage imageNamed:@"sphere.png"] CGImage];
    self.emitterSize = CGSizeMake(2.0, 2.0);
    self.emitterShape = kCAEmitterLayerCircle;
    self.emitterMode = kCAEmitterLayerOutline;
    self.renderMode = kCAEmitterLayerUnordered;
    self.emitterCells = [NSArray arrayWithObject:self.cell];
}

- (void)configureSmoke
{
    self.emitterZPosition = 10;
    self.cell = [CAEmitterCell emitterCell];
    self.cell.scale = 0.01;
    self.cell.scaleRange = 0.2;
    self.cell.emissionRange = (CGFloat)M_PI_2;
    self.cell.lifetime = 0.6;
    self.cell.lifetimeRange = 0.1;
    self.cell.birthRate = 50;
    self.cell.velocity = 20;
    self.cell.velocityRange = 5;
    self.cell.yAcceleration = 0;
    self.cell.spin = 1.1;
    self.cell.spinRange = 0.1;
    self.cell.contents = (id)[[UIImage imageNamed:@"fail.png"] CGImage];
    self.emitterSize = CGSizeMake(2.0, 2.0);
    self.emitterShape = kCAEmitterLayerCircle;
    self.emitterMode = kCAEmitterLayerOutline;
    self.renderMode = kCAEmitterLayerUnordered;
    self.emitterCells = [NSArray arrayWithObject:self.cell];
}

- (void)configureFire
{
    self.emitterZPosition = 10;
    self.cell = [CAEmitterCell emitterCell];
    self.cell.scale = 0.1;
    self.cell.scaleRange = 0.5;
    self.cell.scaleSpeed = -2.0;
    self.cell.emissionRange = (CGFloat)M_PI_2;
    self.cell.lifetime = 0.6;
    self.cell.lifetimeRange = 0.1;
    self.cell.birthRate = 1500;
    self.cell.velocity = 20;
    self.cell.velocityRange = 5;
    self.cell.yAcceleration = 0;
    self.cell.spin = 1.1;
    self.cell.spinRange = 0.1;
    self.cell.contents = (id)[[UIImage imageNamed:@"fire.png"] CGImage];
    //self.cell.color = [[UIColor darkGrayColor] CGColor];
    self.cell.color = [[TRGColors burntOrange] CGColor];
    self.cell.redRange = 156.0;
    self.cell.redSpeed = 100.5;
    self.cell.greenRange = 0.0;
    self.cell.greenSpeed = 0.0;
    self.cell.blueRange = 0.0;
    self.cell.blueSpeed = 0.0;
    self.cell.alphaSpeed = -2.2;
    self.emitterSize = CGSizeMake(2.0, 2.0);
    self.emitterShape = kCAEmitterLayerCircle;
    self.emitterMode = kCAEmitterLayerOutline;
    self.renderMode = kCAEmitterLayerUnordered;
    self.emitterCells = [NSArray arrayWithObject:self.cell];
}

//+ (TRGEmitterLayer *)emitterLayerBubbles
//{
//    TRGEmitterLayer * emitter = [TRGEmitterLayer layer];
//    
//    emitter.emitterZPosition = 10;
//    
//    emitter.cell = [CAEmitterCell emitterCell];
//    emitter.cell.scale = 0.05;
//    emitter.cell.scaleRange = 0.5;
//    emitter.cell.emissionRange = (CGFloat)M_PI_2;
//    emitter.cell.lifetime = 0.6;
//    emitter.cell.lifetimeRange = 0.1;
//    emitter.cell.birthRate = 150;
//    
//    
//    emitter.cell.velocity = 20;
//    emitter.cell.velocityRange = 5;
//    emitter.cell.yAcceleration = 0;
//    
//    emitter.cell.spin = 1.1;
//    emitter.cell.spinRange = 0.1;
//    
//    
//    emitter.cell.contents = (id)[[UIImage imageNamed:@"sphere.png"] CGImage];
//    
//    
//    emitter.emitterSize = CGSizeMake(2.0, 2.0);
//    emitter.emitterShape = kCAEmitterLayerCircle;
//    emitter.emitterMode = kCAEmitterLayerOutline;
//    
//    emitter.renderMode = kCAEmitterLayerUnordered;
//    
//    emitter.emitterCells = [NSArray arrayWithObject:emitter.cell];
//    
//    return emitter;
//}
//
//+ (TRGEmitterLayer *)emitterLayerFireRing
//{
//    TRGEmitterLayer * emitter = [TRGEmitterLayer layer];
//    
//    emitter.emitterZPosition = 10;
//    
//    emitter.cell = [CAEmitterCell emitterCell];
//    emitter.cell.scale = 0.1;
//    emitter.cell.scaleRange = 0.5;
//    emitter.cell.scaleSpeed = -2.0;
//    emitter.cell.emissionRange = (CGFloat)M_PI_2;
//    emitter.cell.lifetime = 0.6;
//    emitter.cell.lifetimeRange = 0.1;
//    emitter.cell.birthRate = 1500;
//    
//    
//    emitter.cell.velocity = 20;
//    emitter.cell.velocityRange = 5;
//    emitter.cell.yAcceleration = 0;
//    
//    emitter.cell.spin = 1.1;
//    emitter.cell.spinRange = 0.1;
//    
//    emitter.cell.contents = (id)[[UIImage imageNamed:@"fire.png"] CGImage];
//    
//    //emitter.cell.color = [[UIColor darkGrayColor] CGColor];
//    emitter.cell.color = [[TRGColors burntOrange] CGColor];
//    emitter.cell.redRange = 156.0;
//    emitter.cell.redSpeed = 100.5;
//    emitter.cell.greenRange = 0.0;
//    emitter.cell.greenSpeed = 0.0;
//    emitter.cell.blueRange = 0.0;
//    emitter.cell.blueSpeed = 0.0;
//    emitter.cell.alphaSpeed = -2.2;
//    
//    emitter.emitterSize = CGSizeMake(2.0, 2.0);
//    emitter.emitterShape = kCAEmitterLayerCircle;
//    emitter.emitterMode = kCAEmitterLayerOutline;
//    
//    emitter.renderMode = kCAEmitterLayerUnordered;
//    
//    emitter.emitterCells = [NSArray arrayWithObject:emitter.cell];
//    
//    return emitter;
//}

@end
