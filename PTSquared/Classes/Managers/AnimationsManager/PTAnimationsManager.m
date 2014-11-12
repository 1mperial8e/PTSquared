//
//  TLAnimationsManager.m
//  Trill
//
//  Created by Stas Volskyi on 08.08.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTAnimationsManager.h"

static NSString *const AMOpacityAnimationKey = @"opacity";
static NSString *const AMHideAnimationKey = @"hide";
static NSString *const AMShowHideAnimationKey = @"showHide";

@interface PTAnimationsManager ()

@property (weak, nonatomic) UIView *animatableView;

@end

@implementation PTAnimationsManager

#pragma mark - Lifecycle

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t dispatchOnceT;
    dispatch_once(&dispatchOnceT, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public

- (void)showView:(UIView *)view
{
    [self showView:view withDuration:AMAnimationDuration];
}

- (void)showView:(UIView *)view withDuration:(CGFloat)duration
{
    view.hidden = NO;
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:AMOpacityAnimationKey];
    opacityAnimation.fromValue = @0;
    opacityAnimation.toValue = @1;
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:opacityAnimation forKey:nil];
    view.layer.opacity = 1.0;
}

- (void)hideView:(UIView *)view
{
    [self hideView:view withDuration:AMAnimationDuration];
}

- (void)hideView:(UIView *)view withDuration:(CGFloat)duration
{
    self.animatableView = view;
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:AMOpacityAnimationKey];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.delegate = self;
    [view.layer addAnimation:opacityAnimation forKey:AMHideAnimationKey];
    view.layer.opacity = 0.0;
}

- (void)showAndHideView:(UIView *)view
{
    [self showAndHideView:view withDuration:AMAnimationDuration];
}

- (void)showAndHideView:(UIView *)view withDuration:(CGFloat)duration
{
    self.animatableView = view;
    view.hidden = NO;
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:AMOpacityAnimationKey];
    opacityAnimation.duration = duration * 8;
    opacityAnimation.values = @[@0, @1, @0];
    opacityAnimation.keyTimes = @[@0, @0.5, @1];
    opacityAnimation.delegate = self;
    opacityAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:opacityAnimation forKey:AMShowHideAnimationKey];
    view.layer.opacity = 0.0;
}

#pragma mark - AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.animatableView.layer animationForKey:AMHideAnimationKey]) {
        [self.animatableView.layer removeAnimationForKey:AMHideAnimationKey];
        self.animatableView.hidden = YES;
        self.animatableView.layer.opacity = 1.0;
        if (self.removeAfterHiding) {
            [self.animatableView removeFromSuperview];
            self.removeAfterHiding = NO;
        }
    }
    if (anim == [self.animatableView.layer animationForKey:AMShowHideAnimationKey]) {
        [self.animatableView.layer removeAnimationForKey:AMShowHideAnimationKey];
        self.animatableView.hidden = YES;
        if (self.removeAfterHiding) {
            [self.animatableView removeFromSuperview];
            self.removeAfterHiding = NO;
        }
    }
}

@end
