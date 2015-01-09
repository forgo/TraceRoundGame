//
//  TRGLevel.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/27/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGLevel.h"

@implementation TRGLevel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"Level X";
        self.countdown = [NSNumber numberWithFloat:10.0f];
        self.targets = [NSMutableSet set];
    }
    return self;
}

@end
