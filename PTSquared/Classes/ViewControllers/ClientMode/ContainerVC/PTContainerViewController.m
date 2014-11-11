//
//  PTContainerViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTContainerViewController.h"
#import "PTCMTutorialViewController.h"
#import "PTMenuViewController.h"
#import "PTCMHomeScreenViewController.h"
#import "PTClientNavController.h"

static NSString *const CMTutorialShow = @"CMTutorialShow";
static NSString *const CMClientStoryBoardName= @"ClientMode";

@interface PTContainerViewController ()

@end

@implementation PTContainerViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTutorial];
    
    [self configureMenu];
}

#pragma mark - Private

- (void)showTutorial
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:CMTutorialShow]) {
        PTCMTutorialViewController *tutorialController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"tutorial"];
        [self presentViewController:tutorialController animated:NO completion:^ {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CMTutorialShow];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

- (void)configureMenu
{
    PTMenuViewController *menuViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
    PTCMHomeScreenViewController *homeViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
    PTClientNavController *navController = [[PTClientNavController alloc] initWithRootViewController:homeViewController];
    
    [self addChildViewController:menuViewController];
    [self addChildViewController:navController];
    
    [self.view addSubview:menuViewController.view];
    [self.view addSubview:navController.view];
    
}

@end
