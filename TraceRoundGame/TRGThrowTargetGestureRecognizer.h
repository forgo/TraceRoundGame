//
//  TRGThrowTargetGestureRecognizer.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/29/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "TRGCircle.h"

@protocol TRGThrowTargetGestureRecognizerDelegate;

@interface TRGThrowTargetGestureRecognizer : TRGGestureRecognizer

@property (nonatomic, assign) id<TRGThrowTargetGestureRecognizerDelegate> throwTargetGestureDelegate;

@property (nonatomic) NSMutableArray * touchArray;
@property (nonatomic) TRGCircle * target;
@property (nonatomic, assign) BOOL wasTargetApplyingForces;

@end

@protocol TRGThrowTargetGestureRecognizerDelegate <NSObject>
@required
-(TRGCircle *)targetCircleContainingFirstTouchPoint:(CGPoint)firstTouchPoint;
@end