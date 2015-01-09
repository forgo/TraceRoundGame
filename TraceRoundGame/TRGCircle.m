//
//  TRGCircle.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGCircle.h"
#import "TRGMath.h"
#import "TRGConstants.h"
#import "TRGEmitterLayer.h"
#import "TRGColors.h"

#define ANIMATION_MATCH_DURATION 0.75

#define ANIMATION_FAIL_DURATION 0.25

@implementation TRGCircle

- (id)initWithOrigin:(CGPoint)origin radius:(CGFloat)radius velocity:(CGPoint)velocity clockwise:(BOOL)clockwise type:(TRGCircleType)circleType asSublayerOfLayer:(CALayer *)superlayer
{
    // Allocate Base Layers and Paths for Target
    self = [self init];
    
    if (self) {
        
        self.superlayer = superlayer;
        self.isClockwise = clockwise;
        self.origin = origin;
        self.radius = [self bindRadius:radius];
        self.velocity = [self bindVelocity:velocity];
      
        switch (circleType) {
            case TRGCircleTypeTarget:
            {
                self.layer.lineWidth = [TRGTarget lineWidth];
                self.layer.strokeColor = [UIColor whiteColor].CGColor;
                self.layer.fillColor = [self color].CGColor;
                
                // Only Targets Need to Add Layers for Drawing (Estimates Only Used for Calculation)
                
                [self setupBezier:origin radius:radius];
                [self setupBackgroundBezier:origin radius:radius];
                [self.layer addSublayer:self.backgroundLayer];
                [self setupThrowBezier];
                [self.layer addSublayer:self.throwLayer];
                [self setupDestructionBezier];
                [self.layer addSublayer:self.destructionLayer];
                
                if (self.superlayer != nil) {
                    [self.superlayer addSublayer:self.layer];
                }
                
                
                break;
            }
            case TRGCircleTypeEstimate:
            {
                self.radius = radius;   // Reset Radius to WHatever if Estimate
                self.layer.lineWidth = 1.0f;
                self.layer.strokeColor = [UIColor clearColor].CGColor;
                self.layer.fillColor = [UIColor clearColor].CGColor;
                break;
            }
            default:
            {
                break;
            }
        }
    }
    return self;
}

- (UIColor *)color {
    CGFloat intensity = (self.radius - [TRGTarget minRadius]) / ([TRGTarget maxRadius] - [TRGTarget minRadius]);
    CGFloat hueOffset = 0.5f;
    CGFloat hueSpan = 0.25;
    CGFloat hue = hueOffset + (intensity * hueSpan);
    return [UIColor colorWithHue:hue saturation:1.0f brightness:1.0f alpha:1.0f];
}

#pragma mark - Convenience Initializer Methods
+ (TRGCircle *)targetFromDictionary:(NSDictionary *)dictionary asSublayerOfLayer:(CALayer *)superlayer {
    
    BOOL clockwise, collidable, throwable, destructible, applyForces;
    NSNumber * percentRight, * percentBottom;
    CGFloat xOrigin, yOrigin;
    NSNumber * radiusScale;
    CGFloat radius;
    NSNumber * speedScale, * direction;
    CGFloat radianRotation;
    CGPoint unitDirectionVector, velocity;

    clockwise = [[dictionary objectForKey:@"clockwise"] boolValue];
    collidable = [[dictionary objectForKey:@"collidable"] boolValue];
    throwable = [[dictionary objectForKey:@"throwable"] boolValue];
    destructible = [[dictionary objectForKey:@"destructible"] boolValue];
    applyForces = [[dictionary objectForKey:@"applyForces"] boolValue];
    percentRight = (NSNumber *)[dictionary objectForKey:@"percentRight"];
    percentBottom = (NSNumber *)[dictionary objectForKey:@"percentBottom"];
    xOrigin = percentRight.floatValue * superlayer.bounds.size.width;
    yOrigin = percentBottom.floatValue * superlayer.bounds.size.height;
    radiusScale = (NSNumber *)[dictionary objectForKey:@"radiusScale"];
    radius = [TRGCircle radiusFromScale:radiusScale.floatValue];
    speedScale = (NSNumber *)[dictionary objectForKey:@"speedScale"];
    direction = (NSNumber *)[dictionary objectForKey:@"direction"];
    radianRotation = DEGREES_TO_RADIANS(direction.floatValue);
    unitDirectionVector = [TRGMath rotateVector:[TRGMath unitVectorFromVector:CGPointMake(1.0f, 0.0f)] by:radianRotation];
    velocity = [TRGMath scaleVector:unitDirectionVector by:speedScale.floatValue];
    
    NSLog(@"SPEED SCALE = %4.4f", speedScale.floatValue);
    NSLog(@"VEL = (%4.4f, %4.4f)", velocity.x, velocity.y);
    
    TRGCircle * circle = [[TRGCircle alloc] initWithOrigin:CGPointMake(xOrigin, yOrigin) radius:radius velocity:velocity clockwise:clockwise type:TRGCircleTypeTarget asSublayerOfLayer:superlayer];
    
    [circle toggleCollidable:collidable];
    [circle toggleThrowable:throwable];
    [circle toggleDestructible:destructible];
    [circle useTheForceLuke:applyForces];
    
    return circle;
}

+ (TRGCircle *)estimateWithOrigin:(CGPoint)origin radius:(CGFloat)radius endAngle:(CGFloat)endAngle spanAngle:(CGFloat)spanAngle andClockwise:(BOOL)clockwise asSublayerOfLayer:(CALayer *)superlayer {
    TRGCircle * estimate = [[TRGCircle alloc] initWithOrigin:origin radius:radius velocity:CGPointMake(0.0f, 0.0f) clockwise:clockwise type:TRGCircleTypeEstimate asSublayerOfLayer:superlayer];
    estimate.endAngle = endAngle;
    estimate.spanAngle = spanAngle;
    return estimate;
}

+ (TRGCircle *)randomTargetAsSublayerOfLayer:(CALayer *)superlayer
{
    CGFloat radius = [TRGCircle randomRadius];
    CGPoint origin = [TRGCircle randomOriginInBounds:superlayer.bounds withRadius:radius];
    CGPoint velocity = [TRGCircle randomVelocity];
    return [[TRGCircle alloc] initWithOrigin:origin radius:radius velocity:velocity clockwise:YES type:TRGCircleTypeTarget asSublayerOfLayer:superlayer];
}

#pragma mark - Instance Helper Methods

- (void)setupBezier:(CGPoint)origin radius:(CGFloat)radius {
    [self.bezier addArcWithCenter:self.origin radius:self.radius startAngle:0.0f endAngle:(2.0f*M_PI) clockwise:YES];
    self.layer.path = [self.bezier CGPath];
    self.layer.position = origin;
    self.layer.bounds = CGRectInset(self.bezier.bounds, -0.5f * [TRGTarget lineWidth], -0.5f * [TRGTarget lineWidth]);
}

- (void)setupBackgroundBezier:(CGPoint)origin radius:(CGFloat)radius {
    [self.backgroundBezier addArcWithCenter:self.origin radius:self.radius startAngle:0.0f endAngle:(2.0f*M_PI) clockwise:YES];
    self.backgroundLayer.path = [self.backgroundBezier CGPath];
    self.backgroundLayer.position = origin;
    self.backgroundLayer.bounds = CGRectInset(self.bezier.bounds, -0.5f * [TRGTarget lineWidth], -0.5f * [TRGTarget lineWidth]);
}

- (void)setupThrowBezier {
    [self.throwBezier addArcWithCenter:self.origin radius:[self throwRadius] startAngle:0.0f endAngle:(2.0f*M_PI) clockwise:YES];
    self.throwLayer.path = [self.throwBezier CGPath];
    self.throwLayer.position = self.layer.position;
    self.throwLayer.bounds = self.layer.bounds;
    self.throwLayer.fillColor = [UIColor greenColor].CGColor;
}

- (void)setupDestructionBezier {
    [self.destructionBezier addArcWithCenter:self.origin radius:1.0f startAngle:0.0f endAngle:(2.0f*M_PI) clockwise:YES];
    self.destructionLayer.path = [self.destructionBezier CGPath];
    self.destructionLayer.position = self.layer.position;
    self.destructionLayer.bounds = self.layer.bounds;
    self.destructionLayer.fillColor = [UIColor clearColor].CGColor;
}

- (CGFloat)bindRadius:(CGFloat)radius {
    return radius < [TRGTarget minRadius] ? [TRGTarget minRadius] :
    radius > [TRGTarget maxRadius] ? [TRGTarget maxRadius] : radius;
}

- (CGPoint)bindVelocity:(CGPoint)velocity {
    CGFloat speed = [TRGMath magnitude:velocity];
    CGFloat boundSpeed = speed < [TRGTarget minSpeed] ? [TRGTarget minSpeed] :
    speed > [TRGTarget maxSpeed] ? [TRGTarget maxSpeed] : speed;
    return [TRGMath scaleVector:[TRGMath unitVectorFromVector:velocity] by:boundSpeed];
}

- (CGFloat)effectiveRadius {
    return (self.radius + [TRGTarget lineWidth] * 0.5f);
}

-(CGFloat)throwRadius {
    return self.isThrowable ? (self.radius / 2.0f) : 0.0f;
}

- (CGPoint)minimumCollisionPoint {
    CGFloat minXCollides = [self effectiveRadius];
    CGFloat minYCollides = [self effectiveRadius];
    return CGPointMake(minXCollides, minYCollides);
}

- (CGPoint)maximumCollisionPoint {
    CGFloat maxXCollides = self.superlayer.bounds.size.width - [self effectiveRadius];
    CGFloat maxYCollides = self.superlayer.bounds.size.height - [self effectiveRadius];
    return CGPointMake(maxXCollides, maxYCollides);
}

- (CGPoint)minimumOutOfBoundsPoint {
    CGFloat minXOutOfBounds = -[self effectiveRadius];
    CGFloat minYOutOfBounds = -[self effectiveRadius];
    return CGPointMake(minXOutOfBounds, minYOutOfBounds);
}

- (CGPoint)maximumOutOfBoundsPoint {
    CGFloat maxXOutOfBounds = self.superlayer.bounds.size.width + [self effectiveRadius];
    CGFloat maxYOutOfBounds = self.superlayer.bounds.size.height + [self effectiveRadius];
    return CGPointMake(maxXOutOfBounds, maxYOutOfBounds);
}

- (BOOL)isCollidingWithBounds {
    BOOL colliding = NO;
    
    CGFloat x, y, Vx, Vy;
    
    x = self.origin.x;
    y = self.origin.y;
    Vx = self.velocity.x;
    Vy = self.velocity.y;
    
    CGPoint min = [self minimumCollisionPoint];
    CGPoint max = [self maximumCollisionPoint];
    
    if (self.origin.x < min.x) {
        x = min.x;
        Vx = -self.velocity.x;
        colliding = YES;
    }
    if (self.origin.y < min.y) {
        y = min.y;
        Vy = -self.velocity.y;
        colliding = YES;
    }
    
    if (self.origin.x > max.x) {
        x = max.x;
        Vx = -self.velocity.x;
        colliding = YES;
    }
    
    if (self.origin.y > max.y) {
        y = max.y;
        Vy = -self.velocity.y;
        colliding = YES;
    }
    
    if (colliding) {
        self.origin = CGPointMake(x, y);
        self.layer.position = self.origin;
        self.velocity = [TRGMath scaleVector:CGPointMake(Vx, Vy) by:TARGET_COEFFICIENT_OF_RESTITUTION];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isOutOfBounds {
    BOOL outOfBounds = NO;
    
    CGPoint min = [self minimumOutOfBoundsPoint];
    CGPoint max = [self maximumOutOfBoundsPoint];
    
    if (self.origin.x < min.x) {
        outOfBounds = YES;
    }
    if (self.origin.y < min.y) {
        outOfBounds = YES;
    }
    
    if (self.origin.x > max.x) {
        outOfBounds = YES;
    }
    
    if (self.origin.y > max.y) {
        outOfBounds = YES;
    }
    
    return outOfBounds;
}

#pragma mark - Instance Gameplay Methods
- (void)disable {
    self.isActive = NO;
    self.layer.hidden = YES;
}
- (void)enable {
    self.isActive = YES;
    self.layer.hidden = NO;
}

- (CGFloat)points {
    return 100.0f;
}

- (CGPoint)sumOfForces {
    CGPoint sum = [self gravity];
    return sum;
}

- (void)move {
    
    CGPoint dV = [TRGMath scaleVector:[self sumOfForces] by:TARGET_DT];
    self.velocity = [TRGMath addVector:dV with:self.velocity];
    
    CGPoint dP = [TRGMath scaleVector:self.velocity by:TARGET_DT];
    self.origin = [TRGMath addVector:dP with:self.origin];
    self.layer.position = self.origin;
    
    // Collision Detection With Bounds and Corresponding Position/Velocity Update
    if (self.isCollidable) {
        [self isCollidingWithBounds];
    }
    // When Collisions Are Disabled See if Circle Has Gone Offscreen So It Can Be Disabled/Hidden
    else if ([self isOutOfBounds]) {
        [self disable];
    }
    
    // TODO: If end up using this for real, need to be more efficient by not duplicating collision tests
    //  -> Get to nlogn instead of n^2
    // Collision Detection of Targets Hitting Each other
    //                [self.targetCircleSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    //                    if ([obj isKindOfClass:[TRGCircle class]]) {
    //                        TRGCircle * tgt2 = (TRGCircle *)obj;
    //
    //                        if (tgt != tgt2) {
    //                            [self collisionDetectedBetweenTarget:tgt and:tgt2];
    //                        }
    //
    //
    //                    }
    //                }];
}

- (void)moveBy:(CGPoint)dxdy {
    CGFloat newX = self.origin.x + dxdy.x;
    CGFloat newY = self.origin.y + dxdy.y;
    CGPoint newPoint = CGPointMake(newX, newY);
    
    self.origin = newPoint;
    self.layer.position = newPoint;
    
    // Collision Detection With Bounds and Corresponding Position/Velocity Update
    if (self.isCollidable) {
        [self isCollidingWithBounds];
    }
    // When Collisions Are Disabled See if Circle Has Gone Offscreen So It Can Be Disabled/Hidden
    else if ([self isOutOfBounds]) {
        [self disable];
    }
}

-(void)stop {
    self.velocity = CGPointMake(0.0f, 0.0f);
}

-(void)toggleCollidable:(BOOL)collidable {
    self.isCollidable = collidable;
    
    if (self.isCollidable) {
        self.layer.strokeColor = [UIColor redColor].CGColor;
        
    }
    else {
        self.layer.strokeColor = [UIColor whiteColor].CGColor;
    }
}

-(void)toggleThrowable:(BOOL)throwable {
    self.isThrowable = throwable;
    
    if (self.isThrowable) {
        self.layer.lineDashPattern = @[@10,@5];
    }
    else {
        self.layer.lineDashPattern = nil;
    }
    
    [self setupThrowBezier];
}

-(void)toggleDestructible:(BOOL)destructible {
    self.isDestructible = destructible;

    if (self.isDestructible) {
        self.layer.fillColor = [self color].CGColor;
    }
    else {
        self.layer.fillColor = [self color].CGColor;
        self.backgroundLayer.fillColor = [TRGColors hexagonPattern].CGColor;
        
        
        
        //        // Add Layer Dedicated to Repeat Pattern On Top of Solid Background Color
        //        CALayer * repeatBackgroundLayer = [CALayer layer];
        //        repeatBackgroundLayer.frame = self.bounds;
        //        repeatBackgroundLayer.backgroundColor = [TRGColors hexagonPattern].CGColor;
        //        [self.layer addSublayer:repeatBackgroundLayer];

        
    }
}

-(void)useTheForceLuke:(BOOL)useTheForce {
    self.isApplyingForces = useTheForce;
    
    if (self.isApplyingForces) {
        self.layer.opacity = 1.0f;
    }
    else {
        self.layer.opacity = 0.5f;
    }
}

#pragma mark - Animations
- (void)destroy {
    
    // Send Notification That Destruction is Beginning
    [[NSNotificationCenter defaultCenter] postNotificationName:kTRGCircleDidStartDestructioneNotification object:self userInfo:nil];

    
    [TRGEmitterLayer sharedBubbles].cell.contents = (id)[[UIImage imageNamed:@"colorwheel.png"] CGImage];
    

    TRGEmitterLayer * fire = [TRGEmitterLayer fire];
    
    [CATransaction begin]; {
        
        // Remove Any Target Circles Marked as Matched On Completion of Animation
        [CATransaction setCompletionBlock:^{
            // Disable Circle So It's Irrelevant in Gameplay
            [self disable];
            
            // Return bubbles to standard image contents of cell
            [TRGEmitterLayer sharedBubbles].cell.contents = (id)[[UIImage imageNamed:@"sphere.png"] CGImage];
            
            // Send Notification That Destruction is Over
            [[NSNotificationCenter defaultCenter] postNotificationName:kTRGCircleDidFinishDestructioneNotification object:self userInfo:nil];

        }];
        
        // Bring Circle to Foreground
        self.layer.zPosition = 999.0f;
        
        // Fire Should Be Foremost in Foreground
        fire.zPosition = 1000.0f;
        
        // Animate Ring of Fire
        [CATransaction begin]; {
            
            // Remove Any Target Circles Marked as Matched On Completion of Animation
            [CATransaction setCompletionBlock:^{
                // Ensure The Emitter is "OFF"
                fire.lifetime = 0;
                
                // Remove Fire Emitter Layer from Superlayer for this Destruction
                [fire removeFromSuperlayer];
            }];
            
            // Set Final Position Before Animation to Avoid Weird Artifacts at Incorrect Stale Default
            fire.emitterPosition = self.origin;
            CGSize startSize = CGSizeMake(0.0f, 0.0f);
            CGSize endSize = CGSizeMake(self.radius*2.0f, self.radius*2.0f);
            fire.emitterSize = endSize;
            
            // Ensure The Emitter is "ON"
            fire.lifetime = 1;
            
            // Add Fire Emitter to Superlayer for This Particular Destruction
            [self.superlayer addSublayer:fire];
            
            CABasicAnimation * emitterAnimation = [CABasicAnimation animationWithKeyPath:@"emitterSize"];
            emitterAnimation.duration = ANIMATION_MATCH_DURATION;
            emitterAnimation.fromValue = (id)[NSValue valueWithCGSize:startSize];
            emitterAnimation.toValue = (id)[NSValue valueWithCGSize:endSize];
            [fire addAnimation:emitterAnimation forKey:@"emitterSize"];
            

            
        } [CATransaction commit];
        
        // Animate Burn Layer (Circle disappearing from inside out)
        self.destructionLayer.fillColor = [UIColor redColor].CGColor;
        CABasicAnimation * burnAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        burnAnimation.duration = ANIMATION_MATCH_DURATION;
        burnAnimation.fromValue = (id)[NSNumber numberWithFloat:1.0f];
        burnAnimation.toValue = (id)[NSNumber numberWithFloat:self.radius];
        [self.destructionLayer addAnimation:burnAnimation forKey:@"transform.scale"];
        
        
        // Animate Disappearance Of Border
        CABasicAnimation * lineExpand = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        lineExpand.duration = ANIMATION_MATCH_DURATION;
        //        lineExpand.fromValue = (id)[NSNumber numberWithFloat:1.0f];
        lineExpand.toValue = (id)[NSNumber numberWithFloat:0.0f];
        [self.layer addAnimation:lineExpand forKey:@"lineWidth"];
        
    } [CATransaction commit];
}

//- (void)miss {
//    
//    [CATransaction begin]; {
//        
//        // Do Stuff After Animation is Done
//        [CATransaction setCompletionBlock:^{
//            // TODO
//        }];
//        
//        // Animate to Yellow To Indicate Failed Target Match
//        CABasicAnimation * redAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
//        redAnimation.duration = ANIMATION_FAIL_DURATION;
//        redAnimation.toValue = (id)[[UIColor yellowColor] CGColor];
//        redAnimation.repeatCount = 1;
//        redAnimation.autoreverses = YES;
//        [self.layer addAnimation:redAnimation forKey:@"fillColor"];
//        
//    } [CATransaction commit];
//}

- (void)miss {
    
    // Rotate The Particle Emitter So Tracing The Bezier Path Follows from The Angle Left Off
    NSLog(@"smoke em position before = %4.4f, %4.4f",[TRGEmitterLayer sharedSmoke].emitterPosition.x, [TRGEmitterLayer sharedSmoke].emitterPosition.y);
    
    CGFloat startAngle = self.endAngle - self.spanAngle;
    CGFloat numRotations = fabs(self.spanAngle) / (2.0f * M_PI);
    
    CATransform3D transform3 = CATransform3DIdentity;
    transform3 = CATransform3DTranslate(transform3, self.origin.x, self.origin.y, 0.0f);
    transform3 = CATransform3DRotate(transform3, -startAngle, 0.0f, 0.0f, 1.0f);
    transform3 = CATransform3DTranslate(transform3, -self.origin.x, -self.origin.y, 0.0f);
    [TRGEmitterLayer sharedSmoke].transform = transform3;
    
    NSLog(@"smoke em position after = %4.4f, %4.4f",[TRGEmitterLayer sharedSmoke].emitterPosition.x, [TRGEmitterLayer sharedSmoke].emitterPosition.y);
    
    [CATransaction begin]; {
        
        // Remove Any Target Circles Marked as Matched On Completion of Animation
        [CATransaction setCompletionBlock:^{
            [TRGEmitterLayer sharedSmoke].lifetime = 0;
        }];
        
        // Ensure The Emitter is "ON"
        [TRGEmitterLayer sharedSmoke].lifetime = 1;
        [TRGEmitterLayer sharedSmoke].emitterPosition = self.bezier.currentPoint;
        


        
        CAKeyframeAnimation * smokeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
        [smokeAnimation setPath:self.layer.path];
        [smokeAnimation setSpeed:(self.isClockwise ? 1.0f : -1.0f)];
        [smokeAnimation setDuration:1.0];
        [smokeAnimation setRepeatCount: numRotations];
        [smokeAnimation setCalculationMode:kCAAnimationPaced];
        [[TRGEmitterLayer sharedSmoke] addAnimation:smokeAnimation forKey:@"emitterPosition"];
        
    } [CATransaction commit];
    

}

// TODO: Figure out what the hell is wrong with this collision detection
// The targets colliding with eachother might not even be worth it for this...
//- (BOOL)collisionDetectedBetweenTarget:(TRGCircle *)c1 and:(TRGCircle *)c2
//{
//    BOOL collided = NO;
//    CGFloat distanceOverlapped;
//    CGFloat distanceCollision = c1.radius + c2.radius;
//    CGFloat distanceSquared = [MathUtilities distanceSquared:c1.origin to:c2.origin];
//    CGFloat distanceCollisionSquared = [MathUtilities squaredValue:distanceCollision];
//
//    if (distanceSquared <= distanceCollisionSquared) {
//        collided = YES;
//        distanceOverlapped = distanceCollision - sqrtf(distanceSquared);
//
//        NSLog(@"-------------COLLISION DETECTED---------------------");
//        NSLog(@"Tangent Collision Distance = %3.2f", distanceCollision);
//        NSLog(@"(C1x,C1y) = (%3.2f,%3.2f) and RC1 = %3.2f", c1.origin.x, c1.origin.y, c1.radius);
//        NSLog(@"(C2x,C2y) = (%3.2f,%3.2f) and RC2 = %3.2f", c2.origin.x, c2.origin.y, c2.radius);
//        NSLog(@"Distance Overlapped = %3.2f", distanceOverlapped);
//
//
//        CGPoint unitNormal = [MathUtilities unitVectorFromVector:[MathUtilities vectorFrom:c1.origin to:c2.origin]];
//        CGPoint unitTangent = [MathUtilities unitTangentFromVector:unitNormal];
//
//        CGPoint relativeVelocity = CGPointMake(c1.velocity.x-c2.velocity.x, c2.velocity.y-c2.velocity.y);
//        CGFloat length = [MathUtilities dotProduct:relativeVelocity with:unitTangent];
//
//        CGPoint velCompParallelTangent = [MathUtilities scaleVector:unitTangent by:length];
//        CGPoint velCompPerpendicularTangent = [MathUtilities vectorFrom:velCompParallelTangent to:relativeVelocity];
//
//        CGFloat c1Vnewx = c1.velocity.x - velCompPerpendicularTangent.x;
//        CGFloat c1Vnewy = c1.velocity.y - velCompPerpendicularTangent.y;
//
//        CGFloat c2Vnewx = c2.velocity.x + velCompPerpendicularTangent.x;
//        CGFloat c2Vnewy = c2.velocity.y + velCompPerpendicularTangent.y;
//
//        //[c1 setOrigin:CGPointMake(newC1x, newC1y)];
//        [c1 setVelocity:CGPointMake(-c1Vnewx, c1Vnewy)];
//        [c2 setOrigin:[MathUtilities addVector:c2.origin with:[MathUtilities scaleVector:unitNormal by:distanceOverlapped]]];
//        [c2 setVelocity:CGPointMake(c2Vnewx, -c2Vnewy)];
//    }
//    return collided;
//}

#pragma mark - Logging Methods
- (NSString *) description {
    
    NSString * result = @"\nTRGCircle {\n";
    
    NSString * radius =         [NSString stringWithFormat:@"\tradius   = %4.4f\n", self.radius];
    NSString * position =       [NSString stringWithFormat:@"\tposition = (%4.4f, %4.4f)\n", self.layer.position.x, self.layer.position.y];
    NSString * velocity =       [NSString stringWithFormat:@"\tvelocity = (%4.4f, %4.4f)\n", self.velocity.x, self.velocity.y];
    NSString * active =         [NSString stringWithFormat:@"\tactive = %@\n", self.isActive ? @"YES" : @"NO"];
    NSString * collidable =     [NSString stringWithFormat:@"\tcollidable = %@\n", self.isCollidable ? @"YES" : @"NO"];
    NSString * throwable =      [NSString stringWithFormat:@"\tthrowable = %@\n", self.isThrowable ? @"YES" : @"NO"];
    NSString * destructible =   [NSString stringWithFormat:@"\tdestructible = %@\n", self.isDestructible ? @"YES" : @"NO"];
    NSString * applyForces =    [NSString stringWithFormat:@"\tapplyForces = %@", self.isApplyingForces ? @"YES" : @"NO"];
    
    result = [result stringByAppendingString:radius];
    result = [result stringByAppendingString:position];
    result = [result stringByAppendingString:velocity];
    result = [result stringByAppendingString:collidable];
    result = [result stringByAppendingString:active];
    result = [result stringByAppendingString:throwable];
    result = [result stringByAppendingString:destructible];
    result = [result stringByAppendingString:applyForces];

    result = [result stringByAppendingString:@"\n}"];
    
    return result;
}

@end
