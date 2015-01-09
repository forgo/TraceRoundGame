//
//  TRGLevelController.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/27/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRGLevelController : NSObject

@property (nonatomic, assign) NSUInteger currentLevel;
@property (nonatomic) NSMutableArray * levels;

- (void)next;
- (void)previous;

@end
