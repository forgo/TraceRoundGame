//
//  TRGCircle.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

typedef NS_ENUM(NSInteger, TRGCircleType) {
    TRGCircleTypeTarget,
    TRGCircleTypeEstimate
};

#import <Foundation/Foundation.h>
#import "TRGTarget.h"

@protocol TRGCircleDelegate;

@interface TRGCircle : TRGTarget <TRGTargetProtocol>

@property (nonatomic) CGFloat radius;

// Convenience Initializer Methods
- (id)initWithOrigin:(CGPoint)origin radius:(CGFloat)radius velocity:(CGPoint)velocity clockwise:(BOOL)clockwise type:(TRGCircleType)circleType asSublayerOfLayer:(CALayer *)superlayer;
+ (TRGCircle *)randomTargetAsSublayerOfLayer:(CALayer *)superlayer;
+ (TRGCircle *)targetFromDictionary:(NSDictionary *)dictionary asSublayerOfLayer:(CALayer *)superlayer;
+ (TRGCircle *)estimateWithOrigin:(CGPoint)origin radius:(CGFloat)radius endAngle:(CGFloat)endAngle spanAngle:(CGFloat)spanAngle andClockwise:(BOOL)clockwise asSublayerOfLayer:(CALayer *)superlayer;

@end

