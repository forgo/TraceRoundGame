//
//  TRGMath.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEGREES_TO_RADIANS(degrees) ((degrees) / 180.0f * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0f / M_PI))

@interface TRGMath : NSObject

+ (CGPoint) addVector:(CGPoint)v1 with:(CGPoint)v2;
+ (CGPoint) vectorFrom:(CGPoint)p1 to:(CGPoint)p2;
+ (CGFloat) squaredValue:(CGFloat)valueToBeSquared;
+ (CGFloat) distanceSquared:(CGPoint)p1 to:(CGPoint)p2;
+ (CGFloat) distance:(CGPoint)p1 to:(CGPoint)p2;
+ (CGFloat) magnitude:(CGPoint)p;
+ (CGFloat) dotProduct:(CGPoint)p1 with:(CGPoint)p2;
+ (CGFloat) signedAngleBetween:(CGPoint)p1 and:(CGPoint)p2;
+ (CGPoint) rotateVector:(CGPoint)vec by:(CGFloat)theta;
+ (CGPoint) randomUnitVector;
+ (CGPoint) unitVectorFromVector:(CGPoint)vec;
+ (CGPoint) unitTangentFromVector:(CGPoint)vec;
+ (CGPoint) scaleVector:(CGPoint)vector by:(CGFloat)factor;
+ (CGPoint) randomDirectionVectorOfLength:(CGFloat)length;
+ (CGFloat) randomNumberBetweenMin:(CGFloat)min andMax:(CGFloat)max;

+ (NSMutableArray *) fft:(NSMutableArray *)x;

@end
