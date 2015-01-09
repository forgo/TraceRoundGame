//
//  TRGThrowTargetGestureView.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/29/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGThrowTargetGestureView.h"

@implementation TRGThrowTargetGestureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.gestureRecognizer = [[[TRGThrowTargetGestureRecognizer alloc] init] initWithTarget:self action:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
