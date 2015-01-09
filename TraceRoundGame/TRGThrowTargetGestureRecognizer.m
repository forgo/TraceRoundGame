//
//  TRGThrowTargetGestureRecognizer.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/29/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGThrowTargetGestureRecognizer.h"
#import "TRGMath.h"

@implementation TRGThrowTargetGestureRecognizer

#pragma mark - Inititalizers

// Override this method to associate a target/action pair
// that will be called when Gestures need to examine their state.
-(id)initWithTarget:(id)target action:(SEL)action
{
    if ((self = [super initWithTarget:target action:action]))
    {
        // View Receives All Touches in Multi-Touch Sequence
        self.cancelsTouchesInView = NO;
        
        // Reset Problem Space for New Touch Events
        [self initializeConditions];
    }
    return self;
}

#pragma mark - Something

- (void)initializeConditions
{
    // Allocate Touch Points Array with 0 size if Not Already Alloc'd
    if (!self.touchArray) {
        self.touchArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    // Remove All Objects from Touch Array to Re-Initialize
    else {
        [self.touchArray removeAllObjects];
    }
    
    self.target = nil;
}

#pragma mark - UITouch Intercepts

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    // Fail Discrete Touch Attempt
    if (self.state == UIGestureRecognizerStateChanged)
    {
        self.state = UIGestureRecognizerStateFailed;
    }
    // Begin Throw Target Touches
    else
    {
        CGPoint initialCGTouchPoint = [[touches anyObject] locationInView:self.view];
        
        self.target = [self.throwTargetGestureDelegate targetCircleContainingFirstTouchPoint:initialCGTouchPoint];
        
        if (self.target != nil) {
            
            NSLog(@"%@",[self.target description]);
                        
            self.wasTargetApplyingForces = self.target.isApplyingForces;
            
            // Found a Target, But is It Throwable?
            if (self.target.isThrowable) {
                // Now Stop In Its Tracks so User Touches Take Control of Movement
                [self.target stop];
                
                [self.target useTheForceLuke:NO];
                
            }
            else {
                self.state = UIGestureRecognizerStateCancelled;
            }
        }
        else {
            self.state = UIGestureRecognizerStateCancelled;
        }
        
        NSValue * pointObj = [NSValue value:&initialCGTouchPoint withObjCType:@encode(CGPoint)];
        [self.touchArray addObject:pointObj];
        
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    // Grab current to examine the state of the swipe
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    NSValue * pointObj = [NSValue value:&currentPoint withObjCType:@encode(CGPoint)];
    
    // First touch after initial touch
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged)
    {
        [self.touchArray addObject:pointObj];
        
        // Move the Target Circle the Difference of the Last Two Touch Points, if It Exists
        if (self.target != nil) {
            
            NSUInteger N = [self.touchArray count];
            CGPoint ultimatePoint;
            CGPoint penultimatePoint;
            
            if (N > 1) {
                [[self.touchArray objectAtIndex:(N-1)] getValue:&ultimatePoint];
                [[self.touchArray objectAtIndex:(N-2)] getValue:&penultimatePoint];
                CGFloat dx = ultimatePoint.x - penultimatePoint.x;
                CGFloat dy = ultimatePoint.y - penultimatePoint.y;
                [self.target moveBy:CGPointMake(dx, dy)];
            }

        }
        
        
        self.state = UIGestureRecognizerStateChanged;
    }
    else
    {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    // User Released the Target: Leave it to it's own devices...
    // An Object In Motion Will Stay In Motion...
    if (self.target != nil) {
        
        NSUInteger N = [self.touchArray count];
        CGPoint ultimatePoint;
        CGPoint penultimatePoint;
        
        if (N > 1) {
            [[self.touchArray objectAtIndex:(N-1)] getValue:&ultimatePoint];
            [[self.touchArray objectAtIndex:(N-2)] getValue:&penultimatePoint];
            CGFloat dx = ultimatePoint.x - penultimatePoint.x;
            CGFloat dy = ultimatePoint.y - penultimatePoint.y;
            CGPoint dP = CGPointMake(dx, dy);
            self.target.velocity = [TRGMath scaleVector:dP by:32.0f];
            

        }
        
        [self.target useTheForceLuke:self.wasTargetApplyingForces];
//        [self.gestureDelegate gestureStatus:@"GTFO!" withSuccess:YES];
        
    }
    
    self.state = UIGestureRecognizerStateEnded;
    
    [self reset];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    // Any time we want to fail the gesture, we call cancel which sets
    // the state as failed.  This way, we can catch and produce a response
    // to a failure if necessary in the handler.
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset
{
    [self initializeConditions];
    [super reset];
}

@end
