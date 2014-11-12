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
#import "PTCalendarAccessViewController.h"
#import "PTWorkoutsViewController.h"
#import "PTNutritionViewController.h"
#import "PTProfileViewController.h"
#import "PTLogoutViewController.h"

static NSString *const CMTutorialShow = @"CMTutorialShow";
static NSString *const CMClientStoryBoardName= @"ClientMode";

@interface PTContainerViewController () <PTMenuViewControllerDelegate>

@property (strong, nonatomic) NSArray *menuControllers;
@property (strong, nonatomic) PTClientNavController *navigationController;

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
    if (!self.menuControllers) {
        [self initialisationMenuControllers];
    }
    PTMenuViewController *menuViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
    menuViewController.delegate = self;
    self.navigationController = [[PTClientNavController alloc] initWithRootViewController:self.menuControllers[0]];
    
    [self addChildViewController:menuViewController];
    [self addChildViewController:self.navigationController];
    
    [self.view addSubview:menuViewController.view];
    [self.view addSubview:self.navigationController.view];
}

- (void)initialisationMenuControllers
{
    PTCMHomeScreenViewController *homeViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
    PTCalendarAccessViewController *calendarViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"calendar"];
    PTWorkoutsViewController *workoutViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"workout"];
    PTNutritionViewController *nutritionViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"nutrition"];
    PTProfileViewController *profileViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
    PTLogoutViewController *logoutViewController = [[UIStoryboard storyboardWithName:CMClientStoryBoardName bundle:nil] instantiateViewControllerWithIdentifier:@"logout"];
    
    self.menuControllers = @[homeViewController, calendarViewController, workoutViewController, nutritionViewController, profileViewController, logoutViewController];
}

#pragma mark - PTMenuViewControllerDelegate

- (void)selectMenuItem:(NSInteger)controllerIndex
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:self.menuControllers[controllerIndex]] animated:NO];
    [self.navigationController configureNavigationBar:self.menuControllers[controllerIndex]];
}

@end
