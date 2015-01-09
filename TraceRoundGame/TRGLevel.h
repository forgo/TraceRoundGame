//
//  TRGLevel.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/27/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRGLevel : NSObject

@property (nonatomic) NSString * title;
@property (nonatomic) NSNumber * countdown;
@property (nonatomic) NSMutableSet * targets;

@end
