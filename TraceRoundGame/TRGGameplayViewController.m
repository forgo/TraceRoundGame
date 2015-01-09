//
//  TRGGameplayViewController.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//



#import "TRGGameplayViewController.h"
#import "TRGConstants.h"
#import "TRGAudioController.h"

@interface TRGGameplayViewController ()

@end

@implementation TRGGameplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Level Controller
    self.levelController = [[TRGLevelController alloc] init];
    
	// Do any additional setup after loading the view.
    [self.viewGestureInfo setBackgroundColor:[UIColor whiteColor]];
    
    // Initially Set Title of Play/Pause Button to Initial State Gameplay Provides
    if (self.viewGameplay.paused) {
        self.buttonPlayPause.title = @"Play";
    }
    else {
        self.buttonPlayPause.title = @"Pause";
    }
    
    // Menu View Controllers
    self.menuViewController = [TRGGameplayMenuViewController menu];
    
    // Initialize Gesture Info View
    [self setupGestureInfo];
    [self removeGestureSubviewsAndRecognizers];
        
    // Instantiate Gesture Views (they subsequently init/add their own respective gesture recognizers)
    self.viewCircleGesture = [[TRGCircleGestureView alloc] initWithFrame:self.viewGameplay.bounds];
    self.viewThrowTargetGesture = [[TRGThrowTargetGestureView alloc] initWithFrame:self.viewGameplay.bounds];
    self.viewTouchPath = [[TRGTouchPathView alloc] initWithFrame:self.viewGameplay.bounds];
    
    NSLog(@"zPosition = %4.4f", self.viewTouchPath.layer.zPosition);
    self.viewTouchPath.layer.zPosition = 1001.0f; // Make Sure Finger Touch Path w/Emitter Always On Top
    self.viewGestureInfo.layer.zPosition = 1002.0f; // But Info View Should Still Always Be Above any Animations
    
    // Register Delegates
    self.viewGameplay.gameplayViewDelegate = self;
    
    self.viewCircleGesture.gestureRecognizer.gestureDelegate = self;
    self.viewCircleGesture.gestureRecognizer.circleGestureDelegate = self.viewGameplay;
    
    self.viewThrowTargetGesture.gestureRecognizer.gestureDelegate = self;
    self.viewThrowTargetGesture.gestureRecognizer.throwTargetGestureDelegate = self.viewGameplay;

    // Start Layering Independent Gesture Views On Top of Gameplay View (Touch Path View Goes On Top)
    [self.viewGameplay addSubview:self.viewCircleGesture];
    [self.viewGameplay insertSubview:self.viewThrowTargetGesture aboveSubview:self.viewCircleGesture];
    [self.viewGameplay insertSubview:self.viewTouchPath aboveSubview:self.viewThrowTargetGesture];
    
    // Add Gesture Recognizers all to Gameplay View
    [self.viewGameplay addGestureRecognizer:self.viewCircleGesture.gestureRecognizer];
    [self.viewGameplay addGestureRecognizer:self.viewThrowTargetGesture.gestureRecognizer];
    
    // Restart When View Did Load
    [self restart:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    self.viewCircleGesture.frame = self.viewGameplay.bounds;
    self.viewThrowTargetGesture.frame = self.viewGameplay.bounds;
    self.viewTouchPath.frame = self.viewGameplay.bounds;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Make Game Objects Invisible and Pause Game Until Rotation Finished
    self.viewGameplay.hidden = YES;
    [self.viewGameplay pause];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // Size Gameplay Frame to Newly Rotated Gesture View Bounds
    self.viewCircleGesture.frame = self.viewGameplay.bounds;
    self.viewThrowTargetGesture.frame = self.viewGameplay.bounds;
    self.viewTouchPath.frame = self.viewGameplay.bounds;
    
    // Make Game Objects Visible Again and Proceed by Unpausing Game
    self.viewGameplay.hidden = NO;
    [self.viewGameplay unpause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.labelGestureStatus = nil;
    self.viewTouchPath = nil;
    self.viewCircleGesture = nil;
    self.viewThrowTargetGesture = nil;
    self.viewGameplay = nil;
}

#pragma mark - Gesture Toolbar Actions
- (IBAction)playPause:(id)sender
{
    [self disableToolbarButtons];
    
    if (sender == self.buttonPlayPause) {
        if ([self.buttonPlayPause.title isEqualToString:@"Play"]) {
            self.buttonPlayPause.title = @"Pause";
            [self.viewGameplay unpause];
        }
        else if ([self.buttonPlayPause.title isEqualToString:@"Pause"]) {
            self.buttonPlayPause.title = @"Play";
            [self.viewGameplay pause];
        }
    }
}

-(IBAction)restart:(id)sender
{
    // Reset Score
    [self.viewGameplay updateScore:0.0f];
    
    // Reload Current Level Into Game View
    TRGLevel * currentLevel = [self.levelController.levels objectAtIndex:self.levelController.currentLevel];
    [self.viewGameplay loadLevel:currentLevel];
    
    // Unpause
    [self.viewGameplay unpause];
}

- (IBAction)nextLevel:(id)sender
{
    [self.levelController next];
    [self restart:nil];
}

- (IBAction)previousLevel:(id)sender
{
    [self.levelController previous];
    [self restart:nil];
}

#pragma mark - Convenience Methods

- (void)setupGestureInfo
{
    self.labelGestureStatus.text = @"Draw it!";
    [self.viewGestureInfo setBackgroundColor:[UIColor whiteColor]];
}

- (void)removeGestureSubviewsAndRecognizers
{
    // Remove Subviews from Gesture View (exclude touch path view)
    for (UIView * subviewGesture in self.viewGameplay.subviews)
    {
        // Don't Remove the Touch Path View as it is Re-Used Between Gestures
        if (subviewGesture == self.viewCircleGesture || subviewGesture == self.viewThrowTargetGesture) {
            [subviewGesture removeFromSuperview];
        }
    }
    
    // Remove Gesture Recognizers from Gesture View
    for (UIGestureRecognizer * gestureRecognizer in self.viewGameplay.gestureRecognizers) {
        [self.viewGameplay removeGestureRecognizer:gestureRecognizer];
    }
}

#pragma mark - TRGGameplayViewDelegate Methods
-(void)didPause {
    [self enableToolbarButtons];
}

-(void)didUnpause {
    [self enableToolbarButtons];
}

-(void)didUpdateScore:(CGFloat)score {
    self.labelGestureScore.text = [NSString stringWithFormat: @"%.2f", score];
}


#pragma mark - TRGGestureRecognizerDelegate Methods
-(void)gestureStatus:(NSString *)status withSuccess:(BOOL)success
{
    self.labelGestureStatus.text = status;
    
    // Gesture Was a Success!
    if (success) {
        // Modify Gesture Info View to Reflect Success
        [self.viewGestureInfo setBackgroundColor:[UIColor greenColor]];
    }
    else {
        // Modify Gesture Info View to Reflect Failure
        [self.viewGestureInfo setBackgroundColor:[UIColor yellowColor]];
    }
}

-(void)gestureRecognizerTriggered:(TRGGestureRecognizer *)recognizer {
    if (recognizer == self.viewThrowTargetGesture.gestureRecognizer) {
        NSLog(@"GR triggered: %@", [[recognizer class] description]);
//        self.viewCircleGesture.gestureRecognizer
//        self.viewCircleGesture.gestureRecognizer.state = UIGestureRecognizerStateCancelled;
//        [self.viewCircleGesture.gestureRecognizer reset];
        
    }
}

#pragma mark - Options Menu View Controller Action
- (IBAction)menu:(id)sender
{
    if (IPAD) {
        // Display the Circle Menu View Controller
        
        self.viewGameplay.paused = YES;
        
        if (self.menuPopoverController == nil) {
            self.menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.menuViewController];
            self.menuPopoverController.delegate = self;
        }
        
        self.menuViewController.menuDelegate = self;
        self.menuPopoverController.contentViewController = self.menuViewController;
        self.menuPopoverController.popoverContentSize = self.menuViewController.view.bounds.size;
        
        // Present the options menu popover controller
        [self disableToolbarButtons];
        [self.menuPopoverController presentPopoverFromBarButtonItem:self.buttonOptions permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else {
        NSLog(@"I'm an iPhone, I can't do a menu popover... TODO: something else...");
    }
}

#pragma mark - UIPopoverControllerDelegate Methods
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // Re-Enable Any Disabled Buttons
    [self enableToolbarButtons];
    
    if (popoverController == self.menuPopoverController) {
        // Do Something
        NSLog(@"Did Dismiss Multi Circle Popover");
        self.viewGameplay.paused = NO;
    }
}

-(void)disableToolbarButtons
{
    self.buttonPlayPause.enabled = NO;
    self.buttonRestart.enabled = NO;
    self.buttonOptions.enabled = NO;
}

-(void)enableToolbarButtons
{
    self.buttonPlayPause.enabled = YES;
    self.buttonRestart.enabled = YES;
    self.buttonOptions.enabled = YES;
}

@end
