//
//  TRGTarget.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/30/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGTarget.h"
#import "TRGConstants.h"
#import "TRGMath.h"

@implementation TRGTarget

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer = [CAShapeLayer layer];
        self.bezier = [UIBezierPath bezierPath];
        
        self.backgroundLayer = [CAShapeLayer layer];
        self.backgroundBezier = [UIBezierPath bezierPath];
        
        self.throwLayer = [CAShapeLayer layer];
        self.throwBezier = [UIBezierPath bezierPath];
        
        self.destructionLayer = [CAShapeLayer layer];
        self.destructionBezier = [UIBezierPath bezierPath];
        
        self.endAngle = 0.0f;
        self.spanAngle = 2.0f * M_PI;
        self.isClockwise = YES;
        
        self.isActive = YES;
        self.isCollidable = YES;
        self.isThrowable = NO;
        self.isDestructible = YES;
        self.isApplyingForces = NO;
    }
    return self;
}

- (CGPoint)gravity {
    CGFloat mag =  self.isApplyingForces ? (IPAD ? TARGET_GRAVITY_IPAD : TARGET_GRAVITY_IPHONE) : 0.0f;
    return [TRGMath scaleVector:[TRGMath unitVectorFromVector:CGPointMake(0.0f, 1.0f)] by:mag];
}

+ (CGFloat)lineWidth {
    return IPAD ? TARGET_LINE_WIDTH_IPAD : TARGET_LINE_WIDTH_IPHONE;
}

+ (CGFloat)minSpeed {
    return IPAD ? TARGET_MINIMUM_SPEED_IPAD : TARGET_MINIMUM_SPEED_IPHONE;
}

+ (CGFloat)maxSpeed {
    return IPAD ? TARGET_MAXIMUM_SPEED_IPAD : TARGET_MAXIMUM_SPEED_IPHONE;
}

+ (CGFloat)minRadius {
    return IPAD ? TARGET_MINIMUM_RADIUS_IPAD : TARGET_MINIMUM_RADIUS_IPHONE;
}

+ (CGFloat)maxRadius {
    return IPAD ? TARGET_MAXIMUM_RADIUS_IPAD : TARGET_MAXIMUM_RADIUS_IPHONE;
}

+ (CGFloat)radiusFromScale:(CGFloat)scale {
    return (scale * ([TRGTarget maxRadius] - [TRGTarget minRadius])) + [TRGTarget minRadius];
}

+ (CGFloat)randomRadius {
    return [TRGMath randomNumberBetweenMin:[TRGTarget minRadius] andMax:[TRGTarget maxRadius]];
}

+ (CGPoint)randomOriginInBounds:(CGRect)bounds withRadius:(CGFloat)radius {
    CGFloat effectiveRadius = (radius + [TRGTarget lineWidth] * 0.5f);
    CGFloat minXOrigin = effectiveRadius;
    CGFloat minYOrigin = effectiveRadius;
    CGFloat maxXOrigin = bounds.size.width - effectiveRadius;
    CGFloat maxYOrigin = bounds.size.height - effectiveRadius;
    int x = [TRGMath randomNumberBetweenMin:minXOrigin andMax:maxXOrigin];
    int y = [TRGMath randomNumberBetweenMin:minYOrigin andMax:maxYOrigin];
    return CGPointMake(x, y);
}

+ (CGPoint)randomVelocity {
    return [TRGMath scaleVector:[TRGMath randomUnitVector] by:[TRGMath randomNumberBetweenMin:[TRGTarget minSpeed] andMax:[TRGTarget maxSpeed]]];
}


@end
