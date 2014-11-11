//
//  PTClientNavController.m
//  PTSquared
//
//  Created by Kirill on 11/11/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTClientNavController.h"

static CGFloat const PTCNMenuOffset = 40;
static CGFloat const PTCNMenuAnimationDuration = 0.3f;

@interface PTClientNavController ()

@property (assign, nonatomic) BOOL isMenuOpened;
@property (strong, nonatomic) UIButton *menuButton;
@property (assign, nonatomic) CGPoint startLocation;

@end

@implementation PTClientNavController

#pragma mark - LifeCycle

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self configureNavigationBar:(UIViewController *)rootViewController];
        [self configurePanGesture];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (void)menuButtonPress
{
    CABasicAnimation *animation = [self createAnimationForMenu];
    if (!self.isMenuOpened) {
        animation.fromValue = [NSValue valueWithCGPoint:self.view.center];
        animation.toValue = [NSValue valueWithCGPoint:[self calculateOpenMenuPosition]];
        [self.view.layer addAnimation:animation forKey:nil];
        self.view.layer.position = [self calculateOpenMenuPosition];
    } else {
        animation.fromValue = [NSValue valueWithCGPoint:self.view.center];
        animation.toValue = [NSValue valueWithCGPoint:[self calculateClosedMenuPosition]];
        [self.view.layer addAnimation:animation forKey:nil];
        self.view.layer.position = [self calculateClosedMenuPosition];
    }
    self.isMenuOpened = !self.isMenuOpened;
}

#pragma mark - Private

- (void)configureNavigationBar:(UIViewController *)rootViewController
{
    UIImage *buttonImage = [UIImage imageNamedFile:@"menu"];
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [self.menuButton setImage:buttonImage forState:UIControlStateNormal];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    [self.menuButton addTarget:self action: @selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    rootViewController.navigationItem.leftBarButtonItem = menuBarButton;
}

- (CGPoint)calculateOpenMenuPosition
{
    CGPoint toPoint = self.view.center;
    toPoint.x = self.view.frame.size.width * 1.5f - PTCNMenuOffset;
    return toPoint;
}

- (CGPoint)calculateClosedMenuPosition
{
    CGPoint startPoint = CGPointMake(self.parentViewController.view.frame.size.width / 2, self.parentViewController.view.frame.size.height / 2);
    return startPoint;
}

- (CGPoint)calculateCurrentCenterOfView:(CGPoint)fromCurrentLocation
{
    CGPoint fromPoint = self.view.center;
    fromPoint.x = fromCurrentLocation.x + self.parentViewController.view.frame.size.width / 2;
    return fromPoint;
}

#pragma mark - Animation

- (CABasicAnimation *)createAnimationForMenu
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = PTCNMenuAnimationDuration;
    animation.removedOnCompletion = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

#pragma mark - Gesture

- (void)configurePanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenuButton:)];
    [self.menuButton addGestureRecognizer:panGesture];
}

- (void)panMenuButton:(UIGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.startLocation = [gesture locationInView:self.view];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint currentLocation = [gesture locationInView:self.parentViewController.view];
            [self menuButtonDidMoveAtDistance:(currentLocation.x - self.startLocation.x)];
            self.startLocation = currentLocation;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self endMoveWithLocation:[gesture locationInView:self.parentViewController.view]];
            break;
        }
        default:
            break;
    }
}

- (void)menuButtonDidMoveAtDistance:(CGFloat)distance
{
    CGFloat maxValueX = self.view.frame.size.width - PTCNMenuOffset;
    if (self.view.frame.origin.x >= 0  && self.view.frame.origin.x <= maxValueX) {
        CGPoint center = self.view.center;
        center.x += distance;
        if (center.x >= self.view.frame.size.width / 2 && center.x <= maxValueX + self.view.frame.size.width / 2) {
            self.view.center = center;
        }
    }
}

- (void)endMoveWithLocation:(CGPoint)location
{
    if (location.x != [self calculateOpenMenuPosition].x || location.x != [self calculateClosedMenuPosition].x) {
        
        CABasicAnimation *animation = [self createAnimationForMenu];
        if (!self.isMenuOpened) {
            animation.fromValue = [NSValue valueWithCGPoint:[self calculateCurrentCenterOfView:location]];
            animation.toValue = [NSValue valueWithCGPoint:[self calculateOpenMenuPosition]];
            [self.view.layer addAnimation:animation forKey:nil];
            self.view.layer.position = [self calculateOpenMenuPosition];
        } else {
            animation.fromValue = [NSValue valueWithCGPoint:[self calculateCurrentCenterOfView:location]];
            animation.toValue = [NSValue valueWithCGPoint:[self calculateClosedMenuPosition]];
            [self.view.layer addAnimation:animation forKey:nil];
            self.view.layer.position = [self calculateClosedMenuPosition];
        }
        self.isMenuOpened = !self.isMenuOpened;
    }
}

@end
