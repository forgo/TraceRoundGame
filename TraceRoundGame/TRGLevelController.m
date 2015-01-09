//
//  TRGLevelController.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/27/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGLevelController.h"
#import "TRGLevel.h"

@implementation TRGLevelController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Populate Levels from levels.plist
        [self populateLevels];
        self.currentLevel = 0;
    }
    return self;
}

- (void)populateLevels {
    
    self.levels = [NSMutableArray array];
    
    NSString * filename = @"levels.plist";
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSString * fullPath = [path stringByAppendingPathComponent:filename];
    NSArray * levelArray = [[NSArray alloc] initWithContentsOfFile:fullPath];
    
    for (NSDictionary * levelInfo in levelArray) {
        TRGLevel * level = [[TRGLevel alloc] init];
        level.title = [levelInfo objectForKey:@"title"];
        level.countdown = [levelInfo objectForKey:@"countdown"];
        
        NSArray * targets = [levelInfo objectForKey:@"targets"];
        
        for (NSDictionary * targetInfo in targets) {
            [level.targets addObject:targetInfo];
        }
                
        [self.levels addObject:level];
    }
    
}

- (void)next {
    if ((self.currentLevel + 1) < self.levels.count) {
        self.currentLevel++;
    }
}

- (void)previous {
    if (self.currentLevel > 0) {
        self.currentLevel--;
    }
}

@end
