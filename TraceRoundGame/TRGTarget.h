//
//  TRGTarget.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/30/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

// Approximating Realistic Earthy Gravity
// ~300 ppi * (39.370 [in/m]) -> 11811 [px/m]
// 9.81 [m/s^2] * 11811 [px/m] -> 115865.91 [px/s^2]
// @ 60 Hz, an acceleration step 60 [frame^2/s^2]
// 115865.91 [px/s^2] / 60 [frame^2/s^2] ->  1931.0985 [px/frame^2]

#define TARGET_DT 0.01666666666f            // [s/frame]

#define TARGET_GRAVITY_IPAD 1931.0f            // [px/frame^2]
#define TARGET_GRAVITY_IPHONE 1931.0f          // [px/frame^2]

#define TARGET_COEFFICIENT_OF_RESTITUTION 0.5f  // COR = 1 (elastic), COR < 1 (inelastic), COR = 0 (motion stops at collision)

#define TARGET_LINE_WIDTH_IPAD 10.0f        // [px]
#define TARGET_LINE_WIDTH_IPHONE 3.0f;      // [px]

#define TARGET_MINIMUM_SPEED_IPAD 0.0f      // [px/frame]
#define TARGET_MAXIMUM_SPEED_IPAD 400.0f      // [px/frame]
#define TARGET_MINIMUM_SPEED_IPHONE 0.0f    // [px/frame]
#define TARGET_MAXIMUM_SPEED_IPHONE 100.0f    // [px/frame]

#define TARGET_MINIMUM_RADIUS_IPAD 70.0f    // [px]
#define TARGET_MAXIMUM_RADIUS_IPAD 150.0f   // [px]
#define TARGET_MINIMUM_RADIUS_IPHONE 37.0f  // [px]
#define TARGET_MAXIMUM_RADIUS_IPHONE 70.0f  // [px]

#import <Foundation/Foundation.h>

@protocol TRGTargetProtocol;

@interface TRGTarget : NSObject

@property (nonatomic) CALayer * superlayer;

@property (nonatomic) CAShapeLayer * layer;
@property (nonatomic) UIBezierPath * bezier;

@property (nonatomic) CAShapeLayer * backgroundLayer;
@property (nonatomic) UIBezierPath * backgroundBezier;

@property (nonatomic) CAShapeLayer * throwLayer;
@property (nonatomic) UIBezierPath * throwBezier;

@property (nonatomic) CAShapeLayer * destructionLayer;
@property (nonatomic) UIBezierPath * destructionBezier;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGFloat spanAngle;

@property (nonatomic, assign) BOOL isClockwise;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isCollidable;
@property (nonatomic, assign) BOOL isThrowable;
@property (nonatomic, assign) BOOL isDestructible;
@property (nonatomic, assign) BOOL isApplyingForces;

- (instancetype)init;
- (CGPoint)gravity;

+ (CGFloat)lineWidth;
+ (CGFloat)minSpeed;
+ (CGFloat)maxSpeed;
+ (CGFloat)minRadius;
+ (CGFloat)maxRadius;
+ (CGFloat)radiusFromScale:(CGFloat)scale;
+ (CGFloat)randomRadius;
+ (CGPoint)randomOriginInBounds:(CGRect)bounds withRadius:(CGFloat)radius;
+ (CGPoint)randomVelocity;

@end

@protocol TRGTargetProtocol <NSObject>

// Actions
- (void)disable;
- (void)enable;
- (CGFloat)points;
- (CGFloat)effectiveRadius;
- (CGFloat)throwRadius;
- (void)move;
- (void)moveBy:(CGPoint)dxdy;
- (void)stop;
- (void)toggleCollidable:(BOOL)collidable;
- (void)toggleThrowable:(BOOL)throwable;
- (void)toggleDestructible:(BOOL)destructible;
- (void)useTheForceLuke:(BOOL)useTheForce;

// Animations
- (void)destroy;
- (void)miss;

// Logging
- (NSString *) description;

@end
