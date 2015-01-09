//
//  TRGColors.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGColors.h"

@implementation TRGColors

+(UIColor *) burntOrange { return [UIColor colorWithRed:156.0f/255.0f green:43.0f/255.0f blue:0.0f alpha:1.0f]; };


+(UIColor *) hexagonPattern {
    UIImage * hexagonImage = [UIImage imageNamed:@"hexagon.png"];
    UIImage * scaledImage = [UIImage imageWithCGImage:hexagonImage.CGImage scale:3.0 orientation:UIImageOrientationUp];
    return [UIColor colorWithPatternImage:scaledImage];
}



@end
