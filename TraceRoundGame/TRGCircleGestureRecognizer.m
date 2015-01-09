//
//  TRGCircleGestureRecognizer.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

// Thresholds
#define ERROR_THRESHOLD_FULL_ROTATION   0.10  // percent 1-rotation offset allowed
#define ERROR_THRESHOLD_RADIUS_VARIANCE 0.25  // percent radius variance relative to tgt
#define ERROR_THRESHOLD_RADIUS 0.25           // percent radius offset relative to tgt
#define ERROR_THRESHOLD_ORIGIN 0.25           // percent offset of origins relative to tgt radius
#define ERROR_NON_FINITE_SCORE 100            // score for when  you're so wrong, we can't calculate ectual error

#import "TRGCircleGestureRecognizer.h"
#import "TRGMath.h"

@implementation TRGCircleGestureRecognizer
{
    // Reduced Least Squares Method to Fit Circle
    // http://www.cs.bsu.edu/homepages/kerryj/kjones/circles.pdf
    float sumX, sumY, sumX2, sumY2, sumX3, sumY3, sumXY, sumXY2, sumYX2;
    float A, B, C, D, E;
    float aM, bM, rM;
}

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
    
    
    // Allocate Radius Array with 0 size if Not Already Alloc'd
    if (!self.radiusArray) {
        self.radiusArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    // Remove All Objects from Radius Array to Re-Initialize
    else {
        [self.radiusArray removeAllObjects];
    }
    
    sumX = 0;
    sumY = 0;
    sumX2 = 0;
    sumY2 = 0;
    sumX3 = 0;
    sumY3 = 0;
    sumXY = 0;
    sumXY2 = 0;
    sumYX2 = 0;
}


- (void)incrementSums:(CGPoint)p
{
    float x2 = p.x*p.x;
    float x3 = x2*p.x;
    float y2 = p.y*p.y;
    float y3 = y2*p.y;
    float xy = p.x*p.y;
    float xy2 = p.x*y2;
    float yx2 = p.y*x2;
    
    sumX += p.x;
    sumY += p.y;
    sumX2 += x2;
    sumY2 += y2;
    sumX3 += x3;
    sumY3 += y3;
    sumXY += xy;
    sumXY2 += xy2;
    sumYX2 += yx2;
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
    // Begin Circle Touches
    else
    {
        CGPoint initialCGTouchPoint = [[touches anyObject] locationInView:self.view];

        NSValue * pointObj = [NSValue value:&initialCGTouchPoint withObjCType:@encode(CGPoint)];
        [self.touchArray addObject:pointObj];
        
        // Increment First Sums For Initial Point
        [self incrementSums:initialCGTouchPoint];
        
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
        // Increment Sums for Subsequent Touches
        [self.touchArray addObject:pointObj];
        [self incrementSums:currentPoint];
        
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
    
    
    NSLog(@"eventDesc = %@", [event description]);
    
    NSUInteger N = [self.touchArray count];
    
    // Determine Final Value of Reduced Least-Squares (RLS)
    A = N*sumX2 - sumX*sumX;
    B = N*sumXY - sumX*sumY;
    C = N*sumY2 - sumY*sumY;
    D = 0.5f*(N*sumXY2 - sumX*sumY2 + N*sumX3 - sumX*sumX2);
    E = 0.5f*(N*sumYX2 - sumY*sumX2 + N*sumY3 - sumY*sumY2);
    
    aM = (D*C - B*E) / (A*C - B*B);
    bM = (A*E - B*D) / (A*C - B*B);
    
    // TODO pt2 estimatedOrigin = {aM, bM};
    CGPoint estimatedOrigin = CGPointMake(aM, bM);
    rM = 0.0f;
    float currentRadius = 0.0f;
    float signedSpanAngle = 0.0f;
    
    CGPoint p;
    CGPoint pLast;
    CGPoint vecLast;
    CGPoint vec;
    
    for (int i = 0; i < N; i++) {

        [[self.touchArray objectAtIndex:i] getValue:&p];
        
        //        pt2 p = {cgp.x, cgp.y};
        //        vec2 vec;
        //        vec2 vecLast;
        
        // Calculations for Estimated Radius
        // TODO currentRadius = pt2_distance(estimatedOrigin, p);
        currentRadius = [TRGMath distance:estimatedOrigin to:p];
        NSValue * radiusObject = [NSValue value:&currentRadius withObjCType:@encode(float)];
        [self.radiusArray addObject:radiusObject];
        rM += currentRadius;
        
        if (i > 0) {
            [[self.touchArray objectAtIndex:i-1] getValue:&pLast];
            //pt2 pLast = {cgpLast.x, cgpLast.y};
            // Calculations for Accumulated Angular Span 2PI - MARGIN <= SPAN <= 2PI + MARGIN
            //TODO vec2_sub(vecLast, pLast, estimatedOrigin);
            vecLast = [TRGMath vectorFrom:estimatedOrigin to:pLast];
            //TODO vec2_sub(vec, p, estimatedOrigin);
            vec = [TRGMath vectorFrom:estimatedOrigin to:p];
            
            signedSpanAngle += [TRGMath signedAngleBetween:vecLast and:vec];
        }
    }
    
    // Mean Radius
    rM /= N;
    
    // Delegate for Actions to Be Taken When An Estimate is Discovered
    BOOL nonFiniteEstimate = NO;
    if (isfinite(aM) && isfinite(bM) && isfinite(rM)) {
        
        CGFloat endAngle = [TRGMath signedAngleBetween:CGPointMake(rM, 0.0f) and:vecLast];
        
        self.estimateCircle = [TRGCircle estimateWithOrigin:CGPointMake(aM, bM) radius:rM endAngle:endAngle spanAngle:signedSpanAngle andClockwise:(signedSpanAngle < 0.0f ? YES : NO) asSublayerOfLayer:self.view.layer];
        
        self.targetCircle = [self.circleGestureDelegate targetCircleForEstimatedCircle:self.estimateCircle];
        
        // Came Back with a nil Estimate (No More Targets to Compare Against!)
        if (self.targetCircle == nil) {
            [self.gestureDelegate gestureStatus:@"GAME OVAR" withSuccess:NO];
            self.state = UIGestureRecognizerStateCancelled;
            [self reset];
            return;
        }
    }
    else {
        nonFiniteEstimate = YES;
    }
    
    // Radius Variance Error Shows How Much the Touch Points Vary Relative
    // to the Estimated Origin, And Normalizes Relative to Target Radius
    float rVariance = 0.0f;
    float rSTD = 0.0f;
    for (int i = 0; i < N; i++) {
        float r;
        [[self.radiusArray objectAtIndex:i] getValue:&r];
        rVariance += (r - rM)*(r - rM);
    }
    rVariance = rVariance / (N - 1);
    rSTD = sqrtf(rVariance);
    CGFloat errorRadiusVariance = rSTD/self.targetCircle.radius;
    
    // This Radius Error Simply Tests for Too Big / Too Small Relative to Target
    CGFloat dr = rM-self.targetCircle.radius;
    CGFloat errorRadius = fabsf(dr) / self.targetCircle.radius;
    
    // How Far Away Are the Target/Estimate Origins?
    CGFloat deltaOrigin = [TRGMath distance:self.targetCircle.layer.position to:estimatedOrigin];
    CGFloat errorOrigin = deltaOrigin / self.targetCircle.radius;
    
    sumX = 0;
    sumY = 0;
    sumX2 = 0;
    sumY2 = 0;
    sumX3 = 0;
    sumY3 = 0;
    sumXY = 0;
    sumXY2 = 0;
    sumYX2 = 0;
    
    // Full Rotation Error
    CGFloat errorFullRotation;
    CGFloat fullRotation = 2.0f*M_PI;
    CGFloat spanAngle = fabsf(signedSpanAngle);
    if (spanAngle < fullRotation) {
        // Undershot
        errorFullRotation = 1.0f - (spanAngle/fullRotation);
        NSLog(@"Undershot error %4.4f ",errorFullRotation);
    }
    else {
        // Overshot
        errorFullRotation = -1.0f + (spanAngle/fullRotation);
        NSLog(@"Overshot error %4.4f ",errorFullRotation);
    }
    
    
    NSLog(@"-------------------------------");
    NSLog(@"fullRotation = %f", fullRotation);
    NSLog(@"aM = %f", aM);
    NSLog(@"bM = %f", bM);
    NSLog(@"rM = %f", rM);
    NSLog(@"spanAngle = %f", spanAngle);
    NSLog(@"signedSpanAngle = %f", signedSpanAngle);
    NSLog(@"rVariance = %f", rVariance);
    NSLog(@"rSTD = %f", rSTD);
    NSLog(@"dr = %f", dr);
    NSLog(@"errorFullRotation = %f", errorFullRotation);
    NSLog(@"errorRadiusVariance = %f", errorRadiusVariance);
    NSLog(@"errorRadius = %f", errorRadius);
    NSLog(@"errorOrigin = %f", errorOrigin);
    NSLog(@"---------------END---------------");
    
    CGFloat errorScore = errorFullRotation+errorRadiusVariance+errorRadius+errorOrigin;
    
    if (nonFiniteEstimate) {
        // Fitting Algorithm Resulted in some NaNs or Some Junk
        // This Typically happens when Drawing a Perfectly Straight Line or Single Point
        [self.gestureDelegate gestureStatus:@"Non-Finite Estimate!" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:ERROR_NON_FINITE_SCORE];
    }
    else if (errorRadiusVariance > ERROR_THRESHOLD_RADIUS_VARIANCE) {
        // Standard Deviation of the Radii of Touchpoints to Fitted Circle Center
        // If this is large, chances are you drew a pretty shitty "circle"
        [self.gestureDelegate gestureStatus:@"Large Deviation of Radius (shitty circle)" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:errorScore];
    }
    else if ((spanAngle < fullRotation) && errorFullRotation > ERROR_THRESHOLD_FULL_ROTATION) {
        // If the Span Angle Exceeds Our Threshold, Break Out and Force a Failure
        [self.gestureDelegate gestureStatus:@"Undershot 360 Degrees!" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:errorScore];
    }
    else if ((spanAngle > fullRotation) && errorFullRotation > ERROR_THRESHOLD_FULL_ROTATION) {
        // If the Span Angle Exceeds Our Threshold, Break Out and Force a Failure
        [self.gestureDelegate gestureStatus:@"Overshot 360 Degrees!" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:errorScore];
    }
    else if ( dr >= 0 && errorRadius > ERROR_THRESHOLD_RADIUS) {
        // If The Difference in Radii Between Fitted and Target Circles Exceeds 10%
        [self.gestureDelegate gestureStatus:@"Circle too big!" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:errorScore];
    }
    else if ( dr <= 0 && errorRadius > ERROR_THRESHOLD_RADIUS) {
        // If The Difference in Radii Between Fitted and Target Circles Exceeds 10%
        [self.gestureDelegate gestureStatus:@"Circle too small!" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:errorScore];
    }
    else if (errorOrigin > ERROR_THRESHOLD_ORIGIN) {
        // If The Fit Circle's Center Is Off By More Than The Diameter
        [self.gestureDelegate gestureStatus:@"A little far from home?" withSuccess:NO];
        self.state = UIGestureRecognizerStateCancelled;
        [self.circleGestureDelegate didFailTargetCircle:self.targetCircle usingEstimateCircle:self.estimateCircle withErrorScore:errorScore];
    }
    else {
        // Could It Be... Something Resembling the Circle?!
        // If Destructible, Send the Good Word
        if (self.targetCircle.isDestructible) {
            [self.gestureDelegate gestureStatus:@"Success!" withSuccess:YES];
            [self.circleGestureDelegate didMatchTargetCircle:self.targetCircle withErrorScore:errorScore];
        }
        else {
            [self.gestureDelegate gestureStatus:@"Indestructible." withSuccess:YES];
        }
        
        self.state = UIGestureRecognizerStateEnded;
    }
    
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
