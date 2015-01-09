//
//  TRGThrowTargetGestureView.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/29/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRGThrowTargetGestureRecognizer.h"

@interface TRGThrowTargetGestureView : UIView

@property (strong, nonatomic) TRGThrowTargetGestureRecognizer * gestureRecognizer;

@end
