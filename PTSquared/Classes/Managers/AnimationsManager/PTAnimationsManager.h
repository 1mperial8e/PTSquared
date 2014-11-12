//
//  TLAnimationsManager.h
//  Trill
//
//  Created by Stas Volskyi on 08.08.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

static CGFloat const AMAnimationDuration = 0.2;

@interface PTAnimationsManager:NSObject

@property (assign, nonatomic) BOOL removeAfterHiding;

+ (instancetype)sharedInstance;

- (void)showView:(UIView *)view;
- (void)showView:(UIView *)view withDuration:(CGFloat)duration;

- (void)hideView:(UIView *)view;
- (void)hideView:(UIView *)view withDuration:(CGFloat)duration;

- (void)showAndHideView:(UIView *)view;
- (void)showAndHideView:(UIView *)view withDuration:(CGFloat)duration;

@end
