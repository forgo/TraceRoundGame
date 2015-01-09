//
//  TRGCircleGestureView.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/29/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGCircleGestureView.h"

@implementation TRGCircleGestureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.gestureRecognizer = [[[TRGCircleGestureRecognizer alloc] init] initWithTarget:self action:nil];
    }
    return self;
}

@end
