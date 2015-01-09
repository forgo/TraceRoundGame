//
//  TRGCircleGestureRecognizer.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "TRGCircle.h"

@protocol TRGCircleGestureRecognizerDelegate;

@interface TRGCircleGestureRecognizer : TRGGestureRecognizer <TRGGestureRecognizerDelegate>

@property (nonatomic, assign) id<TRGCircleGestureRecognizerDelegate> circleGestureDelegate;

@property (nonatomic) NSMutableArray * touchArray;
@property (nonatomic) NSMutableArray * radiusArray;
@property (nonatomic) TRGCircle * targetCircle;
@property (nonatomic) TRGCircle * estimateCircle;

@end

@protocol TRGCircleGestureRecognizerDelegate <NSObject>
@required
-(TRGCircle *)targetCircleForEstimatedCircle:(TRGCircle *)estimateCircle;
-(void)didMatchTargetCircle:(TRGCircle *)targetCircle withErrorScore:(CGFloat)score;
-(void)didFailTargetCircle:(TRGCircle *)targetCircle usingEstimateCircle:(TRGCircle *)estimateCircle withErrorScore:(CGFloat)score;
@end