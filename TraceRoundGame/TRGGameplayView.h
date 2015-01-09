//
//  TRGGameplayView.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRGCircleGestureRecognizer.h"
#import "TRGThrowTargetGestureRecognizer.h"
#import "TRGLevel.h"

@protocol TRGGameplayViewDelegate;

@interface TRGGameplayView : UIView <TRGCircleGestureRecognizerDelegate, TRGThrowTargetGestureRecognizerDelegate>

@property (nonatomic, assign) id<TRGGameplayViewDelegate> gameplayViewDelegate;

@property (nonatomic, assign) CGFloat points;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic) NSMutableSet * circles;
@property (nonatomic) CALayer * pauseLayer;

- (void)advanceFrame;
- (void)loadLevel:(TRGLevel *)level;
- (void)generateRandomTargetSet;
- (void)pause;
- (void)unpause;
- (void)updateScore:(CGFloat)score;

@end

@protocol TRGGameplayViewDelegate <NSObject>
@optional
- (void)didPause;
- (void)didUnpause;
- (void)didUpdateScore:(CGFloat)score;
@end
