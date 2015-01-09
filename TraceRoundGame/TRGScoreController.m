//
//  TRGScoreController.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/1/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#define SCORE_DEFAULT 0.0f
#define SCORE_DEFAULT_MULTIPLIER 1.0f
#define SCORE_MAXIMUM_MULTIPLIER 10.0f
#define SCORE_INCREMENT_MULTIPLIER 1.0f

#import "TRGScoreController.h"

@implementation TRGScoreController

+ (instancetype)controller
{
    static dispatch_once_t once;
    static TRGScoreController * controller;
    dispatch_once(&once, ^{
        controller = [[TRGScoreController alloc] init];
        controller.score = SCORE_DEFAULT;
        controller.multiplier = SCORE_DEFAULT_MULTIPLIER;
        
    });
    return controller;
}
- (void)addPoints:(CGFloat)points {
    
}

- (void)subtractPoints:(CGFloat)points {
    
}

- (void)setMultiplier:(CGFloat)multiplier {
    if (multiplier < SCORE_DEFAULT_MULTIPLIER) {
        multiplier = SCORE_DEFAULT_MULTIPLIER;
    }
    else if (multiplier > SCORE_MAXIMUM_MULTIPLIER) {
        multiplier = SCORE_MAXIMUM_MULTIPLIER;
    }
    else {
        multiplier = multiplier;
    }
}

- (void)incrementMultiplier {
    [self setMultiplier:self.multiplier+SCORE_INCREMENT_MULTIPLIER];
}

- (void)decrementMultiplier {
    [self setMultiplier:self.multiplier-SCORE_INCREMENT_MULTIPLIER];
}

- (void)resetMultiplier {
    [self setMultiplier:SCORE_DEFAULT_MULTIPLIER];
}





@end
