//
//  TRGGestureRecognizer.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRGGestureRecognizerDelegate;

@interface TRGGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) id<TRGGestureRecognizerDelegate> gestureDelegate;
@property (nonatomic, retain) NSString * status;

@end

@protocol TRGGestureRecognizerDelegate <NSObject>
@optional
- (void)gestureStatus:(NSString *)status withSuccess:(BOOL)success;
@end