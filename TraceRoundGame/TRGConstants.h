//
//  TRGConstants.h
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/25/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#define IPAD    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#import <Foundation/Foundation.h>

// Notifications
extern NSString * const kTRGCircleDidStartDestructioneNotification;
extern NSString * const kTRGCircleDidFinishDestructioneNotification;

@interface TRGConstants : NSObject

@end
