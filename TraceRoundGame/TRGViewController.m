//
//  TRGViewController.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#import "TRGViewController.h"
#import "TRGConstants.h"

@interface TRGViewController ()

@end

@implementation TRGViewController

- (IBAction)startNewGame:(id)sender
{
    NSString * storyboardName = IPAD ? @"TRGGameplay_iPad" : @"TRGGameplay_iPhone";
    UIStoryboard * storyboardGameplay = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController * gameplayViewController = [storyboardGameplay instantiateInitialViewController];
    [self.navigationController pushViewController:gameplayViewController animated:YES];
}

@end
