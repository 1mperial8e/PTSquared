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
#import <QuartzCore/QuartzCore.h>

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

- (void)clearNavigationBar
{
    UIView *view = [self.navigationController.navigationBar viewWithTag:PTCNImageTag];
    [view removeFromSuperview];
    view = [self.navigationController.navigationBar viewWithTag:PTCNLabelTag];
    [view removeFromSuperview];
}

#pragma mark - PTMenuViewControllerDelegate

- (void)selectMenuItem:(NSInteger)controllerIndex
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (controllerIndex == self.menuControllers.count - 1) {
            PTLogoutViewController *logoutController = [self.menuControllers lastObject];
            UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
#else
            [rootViewController presentViewController:logoutController animated:NO completion:nil];
#endif
        } else {
            if (![self.navigationController.topViewController isEqual:self.menuControllers[controllerIndex]]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                [self.navigationController setViewControllers:[NSArray arrayWithObject:self.menuControllers[controllerIndex]] animated:NO];
                [self clearNavigationBar];
                [self.navigationController configureNavigationBarItems:self.menuControllers[controllerIndex]];
            }
            [self.navigationController menuButtonPress];
        }
    });
}

@end
