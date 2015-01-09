//
//  TRGGameplayMenuViewController.m
//  TraceRoundGame
//
//  Created by Elliott Richerson on 8/23/14.
//  Copyright (c) 2014 Beyond Aphelion. All rights reserved.
//

#define SEG_CONTROL_SMALLER_RADIUS  0
#define SEG_CONTROL_BIGGER_RADIUS   1

#define NUM_CIRCLES_MINIMUM 1
#define NUM_CIRCLES_MAXIMUM 20

#define RADIUS_MIN_OF_MINIMUM 30.0f
#define RADIUS_MAX_OF_MINIMUM 50.0f
#define RADIUS_MIN_OF_MAXIMUM 50.0f
#define RADIUS_MAX_OF_MAXIMUM 100.0f

#import "TRGGameplayMenuViewController.h"

@interface TRGGameplayMenuViewController ()

@end

@implementation TRGGameplayMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Convenience Initializer Methods
+ (TRGGameplayMenuViewController *) menu
{
    TRGGameplayMenuViewController * menuVC = [[TRGGameplayMenuViewController alloc] initWithNibName:@"TRGGameplayMenuViewController" bundle:nil];
//    menuVC.numberOfCircles = NUM_CIRCLES_MINIMUM;
//    [menuVC.sliderNumberOfCircles setValue:0.0f animated:NO];
//    [menuVC.labelValueNumberOfCircles setText:[NSString stringWithFormat:@"%3.0d", NUM_CIRCLES_MINIMUM]];
//    
//    menuVC.minimumRadius = RADIUS_MIN_OF_MINIMUM;
//    [menuVC.sliderMinimumRadius setValue:0.0f animated:NO];
//    [menuVC.labelValueMinimumRadius setText:[NSString stringWithFormat:@"%3.0f", RADIUS_MIN_OF_MINIMUM]];
//    
//    menuVC.maximumRadius = RADIUS_MIN_OF_MAXIMUM;
//    [menuVC.sliderMaximumRadius setValue:0.0f animated:NO];
//    [menuVC.labelValueMaximumRadius setText:[NSString stringWithFormat:@"%3.0f", RADIUS_MIN_OF_MAXIMUM]];
    return menuVC;
}

@end
