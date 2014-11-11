//
//  PTHomeScreenViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTHomeScreenViewController.h"
#import "PTTutorialViewController.h"

static NSString *const PTTutorialShow = @"PTTutorialShow";

@interface PTHomeScreenViewController ()

@end

@implementation PTHomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showTutorial];
}

#pragma mark - Private

- (void)showTutorial
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:PTTutorialShow]) {
        PTTutorialViewController *tutorialController = [[UIStoryboard storyboardWithName:@"TrainerMode" bundle:nil] instantiateViewControllerWithIdentifier:@"tutorial"];
        [self presentViewController:tutorialController animated:NO completion:^ {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PTTutorialShow];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

@end
