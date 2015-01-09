//
//  TRGGameplayMenuViewController.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRGGameplayMenuViewControllerDelegate;

@interface TRGGameplayMenuViewController : UIViewController

@property (nonatomic, assign) id<TRGGameplayMenuViewControllerDelegate> menuDelegate;

// Convenience Initializer Methods
+ (TRGGameplayMenuViewController *) menu;

@end

@protocol TRGGameplayMenuViewControllerDelegate <NSObject>
@optional
- (void)shouldConfirmNumberOfCircles:(NSUInteger)numCircles minRadius:(CGFloat)minRadius andMaxRadius:(CGFloat)maxRadius;
@end