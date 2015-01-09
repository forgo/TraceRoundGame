//
//  TRGCircleGestureView.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/29/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRGCircleGestureRecognizer.h"

@interface TRGCircleGestureView : UIView

// Gesture Recognizers
@property (strong, nonatomic) TRGCircleGestureRecognizer * gestureRecognizer;

@end
