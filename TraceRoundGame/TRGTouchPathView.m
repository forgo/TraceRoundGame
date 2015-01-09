//
//  TRGTouchPathView.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGTouchPathView.h"
#import "TRGEmitterLayer.h"

@implementation TRGTouchPathView
{
    TRGEmitterLayer * _emitterLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Drawing View Layered Programatically (BG should be clear)
        self.backgroundColor = [UIColor clearColor];
        
        // Emitter of Bubbles
        _emitterLayer = [TRGEmitterLayer sharedBubbles];
        [self.layer addSublayer:_emitterLayer];
    }
    return self;
}

#pragma mark - Touch Handling Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    
    // Change Emitter's Position to Current Touch Location
    _emitterLayer.emitterPosition = currentPoint;
    
    // Turn ON Emitting Particles
    _emitterLayer.lifetime = 1;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    
    // Change Emitter's Position to Current Touch Location
    _emitterLayer.emitterPosition = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Effectively Turn OFF Emitting Particles (No Longer Touching)
    _emitterLayer.lifetime = 0;
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Effectively Turn OFF Emitting Particles (No Longer Touching)
    _emitterLayer.lifetime = 0;
}

@end
