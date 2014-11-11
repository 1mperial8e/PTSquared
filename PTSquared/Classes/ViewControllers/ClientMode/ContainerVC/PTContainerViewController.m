//
//  PTContainerViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTContainerViewController.h"
#import "PTCMTutorialViewController.h"

static NSString *const CMTutorialShow = @"CMTutorialShow";

@interface PTContainerViewController ()

@end

@implementation PTContainerViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTutorial];
}

#pragma mark - Private

- (void)showTutorial
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CMTutorialShow]) {
        PTCMTutorialViewController *tutorialController = [[UIStoryboard storyboardWithName:@"ClientMode" bundle:nil] instantiateViewControllerWithIdentifier:@"tutorial"];
        [self presentViewController:tutorialController animated:NO completion:^ {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CMTutorialShow];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

@end
