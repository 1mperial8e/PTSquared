//
//  PTCalendarAccessViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTCalendarAccessViewController.h"
#import "PTProfileManager.h"
#import "PTHomeScreenViewController.h"

@interface PTCalendarAccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoUILabel;

@end

@implementation PTCalendarAccessViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)allowCalendarButtonPress:(id)sender
{
    if ([self getCalendarInformation]) {
        [self finishLoginProcess];
    }
}

- (IBAction)cancellButtonPress:(id)sender
{
    [self finishLoginProcess];
}

#pragma mark - Private

- (BOOL)getCalendarInformation
{
    //TODO
    return YES;
}

- (void)finishLoginProcess
{
    UIViewController *controller;
    switch ([PTProfileManager sharedManager].profileType) {
        case PERSONAL_TRAINER: {
            controller = [[UIStoryboard storyboardWithName:@"TrainerMode" bundle:nil] instantiateInitialViewController];
            break;
        }
        case CLIENT: {
            controller = [[UIStoryboard storyboardWithName:@"ClientMode" bundle:nil] instantiateInitialViewController];
            break;
        }
    }
    [self.navigationController pushViewController:controller animated:YES];
}

@end
