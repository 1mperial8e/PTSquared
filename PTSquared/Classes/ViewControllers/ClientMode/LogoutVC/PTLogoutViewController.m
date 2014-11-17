//
//  PTLogoutViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTLogoutViewController.h"
#import "PTAnimationsManager.h"

@interface PTLogoutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (assign, nonatomic) BOOL showAnimation;

@end

@implementation PTLogoutViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.showAnimation = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.showAnimation) {
        self.showAnimation = NO;
        [[PTAnimationsManager sharedInstance] showView:self.view];
    }
}

#pragma mark - Private

- (void)configureUI
{
    self.confirmButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderWidth = 1.0;
    self.confirmButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
    self.confirmButton.layer.cornerRadius = 8.0;
    self.cancelButton.layer.cornerRadius = 8.0;
}

- (void)createHideAnimation
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    opacityAnimation.duration = 0.3;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.delegate = self;
    [self.view.layer addAnimation:opacityAnimation forKey:@"hide"];
    self.view.layer.opacity = 0.0;
}

#pragma mark - AnimationsDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.view.layer animationForKey:@"hide"]) {
        [self.view.layer removeAnimationForKey:@"hide"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - UIActions

- (IBAction)confirmButton:(id)sender
{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [navController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cancelButton:(id)sender
{
    [self createHideAnimation];
}

@end
