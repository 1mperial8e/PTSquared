//
//  PTClientNavController.m
//  PTSquared
//
//  Created by Kirill on 11/11/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTClientNavController.h"

static CGFloat const PTCNMinMenuActionOffset = 120;
static CGFloat const PTCNMenuOffset = 60;
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
        [self configureNavigationBarStyle];
        [self configureNavigationBarItems:(UIViewController *)rootViewController];
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

#pragma mark - Public

- (void)configureNavigationBarItems:(UIViewController *)rootViewController
{
    UIImage *buttonImage = [UIImage imageNamedFile:@"menu"];
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [self.menuButton setImage:buttonImage forState:UIControlStateNormal];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    [self.menuButton addTarget:self action: @selector(menuButtonPress) forControlEvents:UIControlEventTouchUpInside];
    rootViewController.navigationItem.leftBarButtonItem = menuBarButton;
    
    [self configurePanGesture];
}

- (void)setTitleImageToNavigationBar:(UIImage *)image
{
    CGPoint navBarCenter = self.navigationBar.center;
    CGRect imageFrame = CGRectMake(navBarCenter.x - image.size.width / 2, 0, image.size.width, image.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = imageFrame;
    imageView.tag = PTCNImageTag;
    [self.navigationBar addSubview:imageView];
}

- (void)setTitleLabelToNavigationBar:(NSString *)titleText
{
    if (titleText.length) {
        CGSize navBarSize = self.navigationBar.frame.size;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, navBarSize.width - navBarSize.height * 2,  navBarSize.height)];
        titleLabel.text = titleText;
        titleLabel.minimumScaleFactor = 0.5;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.center = CGPointMake(navBarSize.width / 2, navBarSize.height / 2);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.tag = PTCNLabelTag;
        [self.navigationBar addSubview:titleLabel];
    }
}

#pragma mark - Private

- (void)configureNavigationBarStyle
{
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = UIColorFromRGB(0xB5B5B5);
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.clipsToBounds = YES;
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

- (CGPoint)calculateCurrentCenterOfView:(CGPoint)fromCurrentLocation viewLocation:(CGPoint)viewLocation
{
    CGPoint fromPoint = self.view.center;
    fromPoint.x = fromCurrentLocation.x - viewLocation.x + self.parentViewController.view.frame.size.width / 2;
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
    panGesture.delaysTouchesBegan = NO;
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
            [self endMoveWithGlobalLocation:[gesture locationInView:self.parentViewController.view] viewLocation:[gesture locationInView:self.view]];
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

- (void)endMoveWithGlobalLocation:(CGPoint)location viewLocation:(CGPoint)viewLocation
{
    [self setAnimationDirection:location viewLocation:viewLocation];
    if (location.x != [self calculateOpenMenuPosition].x || location.x != [self calculateClosedMenuPosition].x) {
        
        CABasicAnimation *animation = [self createAnimationForMenu];
        if (!self.isMenuOpened) {
            animation.fromValue = [NSValue valueWithCGPoint:[self calculateCurrentCenterOfView:location viewLocation:viewLocation]];
            animation.toValue = [NSValue valueWithCGPoint:[self calculateOpenMenuPosition]];
            [self.view.layer addAnimation:animation forKey:nil];
            self.view.layer.position = [self calculateOpenMenuPosition];
        } else {
            animation.fromValue = [NSValue valueWithCGPoint:[self calculateCurrentCenterOfView:location viewLocation:viewLocation]];
            animation.toValue = [NSValue valueWithCGPoint:[self calculateClosedMenuPosition]];
            [self.view.layer addAnimation:animation forKey:nil];
            self.view.layer.position = [self calculateClosedMenuPosition];
        }
        self.isMenuOpened = !self.isMenuOpened;
    }
}

- (void)setAnimationDirection:(CGPoint)location viewLocation:(CGPoint)viewLocation
{
    if (self.isMenuOpened) {
        CGFloat pointX = self.parentViewController.view.frame.size.width - PTCNMinMenuActionOffset - PTCNMenuOffset;
        if (location.x - viewLocation.x > pointX){
            self.isMenuOpened = !self.isMenuOpened;
        }
    } else {
        if (location.x - viewLocation.x < PTCNMinMenuActionOffset){
            self.isMenuOpened = !self.isMenuOpened;
        }
    }
}

@end
