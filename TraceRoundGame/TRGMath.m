//
//  TRGMath.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGMath.h"

@implementation TRGMath

// Add two Vectors Together
+ (CGPoint) addVector:(CGPoint)v1 with:(CGPoint)v2
{
    CGPoint addition;
    addition.x = v1.x + v2.x;
    addition.y = v1.y + v2.y;
    return addition;
}

// Calculate the Vector as a CGPoint from Start = p1 to End = p2
+ (CGPoint) vectorFrom:(CGPoint)p1 to:(CGPoint)p2
{
    return CGPointMake(p2.x - p1.x, p2.y - p1.y);
}

// Squares the Value of a CGFloat
+ (CGFloat) squaredValue:(CGFloat)valueToBeSquared
{
    return valueToBeSquared*valueToBeSquared;
}

// Calcualte the Squared Distance Between two CGPoints p1 and p2
+ (CGFloat) distanceSquared:(CGPoint)p1 to:(CGPoint)p2 {
    return (p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y);
}

// Calculate the Distance Between two CGPoints p1 and p2
+ (CGFloat) distance:(CGPoint)p1 to:(CGPoint)p2 {
    return sqrtf((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y));
}

// Claculate the Magnitude of CGPoint p Interpretted as a 2D-Vector
+ (CGFloat) magnitude:(CGPoint)p {
    return sqrtf(p.x*p.x + p.y*p.y);
}

// Calculate the Dot Product of CGPoints p1, and p2, Intrpetted as 2D-Vectors
+ (CGFloat) dotProduct:(CGPoint)p1 with:(CGPoint)p2 {
    return p1.x*p2.x + p1.y*p2.y;
}

// Calculate the Signed Angle Between Two Vectors
+ (CGFloat) signedAngleBetween:(CGPoint)p1 and:(CGPoint)p2 {
    CGFloat angle = atan2f(p1.y, p1.x) - atan2f(p2.y, p2.x);
    if (fabsf(angle) > M_PI) {
        if (angle < 0) {
            angle += 2.0f*M_PI;
        }
        else {
            angle -= 2.0f*M_PI;
        }
    }
    return angle;
}

// Calculate the Vector As A Result of Rotating the Original Vector by Theta Radians
+ (CGPoint) rotateVector:(CGPoint)vec by:(CGFloat)theta
{
    CGPoint rotatedVector;
    rotatedVector.x = vec.x*cosf(theta) - vec.y*sinf(theta);
    rotatedVector.y = vec.x*sinf(theta) + vec.y*cosf(theta);
    return rotatedVector;
}

// Output a Random 2D Unit Vector, by Rotating a Known Unit Vector by Random Angle
+ (CGPoint) randomUnitVector
{
    CGFloat randomRadians = [TRGMath randomNumberBetweenMin:0.0f andMax:(2.0f*M_PI)];
    return [TRGMath rotateVector:CGPointMake(1.0f, 0.0f) by:randomRadians];
}

// Output Unit Vector in Same Direction as Provided Vector (Scaled to Magnitude 1)
+ (CGPoint) unitVectorFromVector:(CGPoint)vec
{
    // Ensure Magnitude Comes Back Finite
    // Otherwise dealing with potential NaN/+Inf/-Inf Which Causes Big Problems
    // and We Will Just Return a Zero Vector In That Case
    CGFloat magScale = 1.0f/[TRGMath magnitude:vec];
    
    if (isfinite(magScale)) {
        return [TRGMath scaleVector:vec by:magScale];
    }
    else {
        return CGPointMake(0.0f, 0.0f);
    }
}

// Output Unit Vector Which is Tangent  to Provided Vector (Scaled to Magnitude 1)
+ (CGPoint) unitTangentFromVector:(CGPoint)vec
{
    CGPoint tangentVec;
    tangentVec.x = -vec.y;
    tangentVec.y = vec.x;
    return [TRGMath unitVectorFromVector:tangentVec];
}

// Scale a Vector By Some Constant Value
+ (CGPoint) scaleVector:(CGPoint)vector by:(CGFloat)factor
{
    CGPoint scaledVector;
    scaledVector.x = vector.x * factor;
    scaledVector.y = vector.y * factor;
    return scaledVector;
}

// Output a Random 2D Vector of Length
+ (CGPoint) randomDirectionVectorOfLength:(CGFloat)length
{
    return [TRGMath scaleVector:[TRGMath randomUnitVector] by:length];
}

// Output a Random Number Between Min and Max
+ (CGFloat) randomNumberBetweenMin:(CGFloat)min andMax:(CGFloat)max
{
    CGFloat randScale = drand48();
    return min + randScale*(max-min);
}

// Calculate the Fast-Fourier Transform of Input Array of CGPoints x
+ (NSMutableArray *) fft:(NSMutableArray *)x {
    
    // Number Of Elements in Data Set
    NSUInteger N = [x count];
    
    if (N <= 1) {
        return x;
    }
    return x;
    
    //    even = [TRGMath fft:[x subarrayWithRange:NSMakeRange
    //
    //
    //
    //
    //    CGPoint initialTouchPoint = [[touches anyObject] locationInView:self.view];
    //
    //    NSValue * pointObj = [NSValue value:&initialTouchPoint withObjCType:@encode(CGPoint)];
    //    [self.touchArray addObject:pointObj];
    //
    //
    //
    //
    //    CGPoint pLast;
    //    [[self.touchArray objectAtIndex:i-1] getValue:&pLast];
    
}

@end
