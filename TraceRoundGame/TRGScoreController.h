//
//  TRGScoreController.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 9/1/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRGScoreController : NSObject

@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) CGFloat multiplier;

- (void)addPoints:(CGFloat)points;
- (void)subtractPoints:(CGFloat)points;
- (void)setMultiplier:(CGFloat)multiplier;
- (void)incrementMultiplier;
- (void)decrementMultiplier;
- (void)resetMultiplier;

@end

@protocol TRGScoreControllerDelegate <NSObject>
@optional
- (void)didPause;
- (void)didUnpause;
- (void)didUpdateScore:(CGFloat)score;
@end
