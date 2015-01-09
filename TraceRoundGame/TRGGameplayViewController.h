//
//  TRGGameplayViewController.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRGGameplayView.h"
#import "TRGGestureRecognizer.h"
#import "TRGGameplayMenuViewController.h"
#import "TRGCircleGestureView.h"
#import "TRGThrowTargetGestureView.h"
#import "TRGTouchPathView.h"
#import "TRGLevelController.h"
#import "TRGScoreController.h"

@interface TRGGameplayViewController : UIViewController <TRGGameplayViewDelegate, TRGGestureRecognizerDelegate, TRGGameplayMenuViewControllerDelegate, UIPopoverControllerDelegate>

// Gesture Info View
@property (nonatomic, weak) IBOutlet UIView * viewGestureInfo;
@property (nonatomic, weak) IBOutlet UILabel * labelGestureStatus;
@property (nonatomic, weak) IBOutlet UILabel * labelGestureScore;

// Gesture View
@property (nonatomic, strong) IBOutlet TRGGameplayView * viewGameplay;

// Gesture View Drawing Subviews (added/removed programatically)
@property (nonatomic) TRGCircleGestureView * viewCircleGesture;
@property (nonatomic) TRGThrowTargetGestureView * viewThrowTargetGesture;
@property (nonatomic) TRGTouchPathView * viewTouchPath;

// Gesture Recognizers
//@property (strong, nonatomic) TRGCircleGestureRecognizer * gestureRecognizerCircle;
//@property (strong, nonatomic) TRGThrowTargetGestureRecognizer * gestureRecognizerThrowTarget;

// Gesture Toolbar
@property (nonatomic, weak) IBOutlet UIBarButtonItem * buttonPlayPause;
@property (nonatomic, weak) IBOutlet UIBarButtonItem * buttonRestart;
@property (nonatomic, weak) IBOutlet UIBarButtonItem * buttonOptions;

// Level Controller
@property (nonatomic) TRGLevelController * levelController;

// Score Controller
@property (nonatomic) TRGScoreController * scoreController;

// Popover Controller and Menu View Controllers
@property (nonatomic) UIPopoverController * menuPopoverController;
@property (nonatomic) TRGGameplayMenuViewController * menuViewController;

- (IBAction)playPause:(id)sender;
- (IBAction)restart:(id)sender;
- (IBAction)menu:(id)sender;
- (IBAction)nextLevel:(id)sender;
- (IBAction)previousLevel:(id)sender;

@end
