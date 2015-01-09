//
//  TRGGameplayView.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#define MAX_NUM_CIRCLES 50
#define POINTS_PER_MATCH 100

#import "TRGGameplayView.h"
#import "TRGEmitterLayer.h"
#import "TRGMath.h"
#import "TRGAudioController.h"
#import "TRGConstants.h"
#import "TRGColors.h"

@interface TRGGameplayView ()

@property TRGAudioController * audioController;

@end

@implementation TRGGameplayView {
    CADisplayLink * _displayLink;
}

-(void)notifiedOfDestructionStart {
    NSLog(@"STARTED DESTRUCTION");
    [self.audioController startDestruction];
}

-(void)notifiedOfDestructionFinish {
    NSLog(@"ENDED DESTRUCTION");

    [self.audioController stopDestruction];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Register to Receive Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedOfDestructionStart) name:kTRGCircleDidStartDestructioneNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedOfDestructionFinish) name:kTRGCircleDidFinishDestructioneNotification object:nil];

        // Initialize Audio Controller
        self.audioController = [[TRGAudioController alloc] init];
        [self.audioController setupAudio];
        
        
        [self updateScore:0.0f];                        // Initialize Score to Zero
        self.paused = YES;                              // Initially Game Will Be Paused
        self.circles = [NSMutableSet set];              // Initilialize Circle Targets to Empty Set
        self.backgroundColor = [TRGColors burntOrange]; // Gameplay Background Color
        
        
    
        [self.layer addSublayer:[TRGEmitterLayer sharedSmoke]];

        // Provides Callback for Motion Updates in Sync with Native Screen Refreshes
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(advanceFrame)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self updateScore:0.0f];                        // Initialize Score to Zero
//        self.paused = YES;                              // Initially Game Will Be Paused
//        self.circles = [NSMutableSet set];              // Initilialize Circle Targets to Empty Set
//        self.backgroundColor = [UIColor clearColor];                            // Drawing View Layered Programatically (BG should be clear)
//        self.layer.contents = (id)[UIImage imageNamed:@"splash.jpg"].CGImage;   // Initialize Gameplay Background
//        
//        [self.layer addSublayer:[TRGEmitterLayer fire]];                        // Add Fire Particle Emitter for Destroyed Circle Targets
//        
//        // Provides Callback for Motion Updates in Sync with Native Screen Refreshes
//        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(advanceFrame)];
//        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//        
//    }
//    return self;
//}

- (void)updateScore:(CGFloat)score {
    self.points = score;
    [self.gameplayViewDelegate didUpdateScore:self.points];
}

- (void)pause {
    self.paused = YES;
    [self.gameplayViewDelegate didPause];
}

- (void)unpause {
    self.paused = NO;
    [self.gameplayViewDelegate didUnpause];
}

#pragma mark - Screen Update Callback
- (void)advanceFrame
{    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    
    for (TRGCircle * target in self.circles) {
        if ([target isKindOfClass:[TRGCircle class]]) {
            if (!self.paused) {
                [target move];
            }
            [self.layer addSublayer:target.layer];
        }
    }
    
    [CATransaction commit];
}

#pragma mark - TRGThrowTargetGestureRecognizerDelegate Methods
-(TRGCircle *)targetCircleContainingFirstTouchPoint:(CGPoint)firstTouchPoint
{
    __block TRGCircle * target, * containingTarget;
    __block CGFloat distance;
    
    // Sort By Greatest zPosition Value First (first match is on top)
    NSSortDescriptor * zPositionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"layer.zPosition" ascending:NO];
    NSArray * zPositionSortedCircles = [self.circles sortedArrayUsingDescriptors:[NSArray arrayWithObject:zPositionSortDescriptor]];
    
    [zPositionSortedCircles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[TRGCircle class]]) {
            
            target = (TRGCircle *)obj;
            distance = [TRGMath distance:target.origin to:firstTouchPoint];
            
            // Use Half Radius to Be Able to Throw Circle (Helps to not conflict with circle matching)
            if (target.isActive &&  distance < (target.radius / 2.0f)) {
                containingTarget = target;
                *stop = YES;
            }
        }

    }];
    
    return containingTarget;
}

#pragma mark - TRGCircleGestureRecognizerDelegate Methods
-(TRGCircle *)targetCircleForEstimatedCircle:(TRGCircle *)estimateCircle
{
    // Obtain Closest Target For Gesture Recognizer to Compare Against
    // Use Straightforward Minimum Distance Between Estimate Origin and Targets
    return [self targetCircleNearestToEstimate:estimateCircle];
}

- (TRGCircle *)targetCircleNearestToEstimate:(TRGCircle *)estimateCircle
{
    __block TRGCircle * target, * nearestTarget;
    __block CGFloat distance, minimum = INFINITY;
    
    [self.circles enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:[TRGCircle class]]) {
            
            target = (TRGCircle *)obj;
            distance = [TRGMath distance:target.origin to:estimateCircle.origin];
            
            if (target.isActive && distance < minimum) {
                minimum = distance;
                nearestTarget = target;
            }
        }
    }];
    
    return nearestTarget;
}

-(void)didMatchTargetCircle:(TRGCircle *)targetCircle withErrorScore:(CGFloat)score
{
    // Set the Velocity To Zero To Stop on Match
    targetCircle.velocity = CGPointMake(0.0f, 0.0f);
    
    // Update the Score
    [self updateScore:(self.points+score+POINTS_PER_MATCH)];
    
    // Animate Circle Burning (Will Delegate Back For Us To Remove Layer)
    [targetCircle destroy];
}

-(void)didFailTargetCircle:(TRGCircle *)targetCircle usingEstimateCircle:(TRGCircle *)estimateCircle withErrorScore:(CGFloat)score
{

    
    // Update the Score
    [self updateScore:(self.points - score)];
    
    // Animate The Circle to Indicate a Failed Match
    [estimateCircle miss];
}

#pragma mark - Convenience Methods
- (void)loadLevel:(TRGLevel *)level {
    
    // Pause When New Level Loaded
    self.paused = YES;
    
    // Remove Any Existing Target Circle Layers in View
    for (TRGCircle * circle in self.circles) {
        [circle.layer removeFromSuperlayer];
    }
    [self.circles removeAllObjects];
    
    // Generate Level Targets in View
    NSLog(@"Load Level Circles Descriptions");

    for (NSDictionary * target in level.targets) {
        TRGCircle * newCircle = [TRGCircle targetFromDictionary:target asSublayerOfLayer:self.layer];
        
        NSLog(@"%@", [newCircle description]);
        
        [self.circles addObject:newCircle];
    }
    
    [self advanceFrame];
}

- (void)generateRandomTargetSet
{
    // First Time Generating a Set?  Don't Worry, I've Got you Covered :)
    if (self.circles == nil) {
        self.circles = [NSMutableSet set];
    }
    // Otherwise We Have a Non-Nil Set... Let's Clean Before Making New Stuff
    else {
        
        
        for (TRGCircle * target in self.circles) {
            if ([target isKindOfClass:[TRGCircle class]]) {
                // Regenerating Targets, Ensure We Remove All Display Layers
                [target.layer removeFromSuperlayer];
            }
        }
        
        // Clear Out Set After Layers Have Been Removed Before Repopulating
        [self.circles removeAllObjects];
    }
    
    for (int i = 1; i <= MAX_NUM_CIRCLES; i++) {
        TRGCircle * newCircle = [TRGCircle randomTargetAsSublayerOfLayer:self.layer];
        [self.circles addObject:newCircle];
        
    }
}



#pragma mark - TRGCircleDelegate
-(void)shouldRemoveCircle:(TRGCircle *)circle {
    // Don't Actually Remove from Circle Set, Simply Make Inactive
    // Avoiding "was mutated whiel being enumerated" errors
    // Could Potentially Re-Use These Circles / Re-Activate Later
    circle.isActive = NO;
}


@end
