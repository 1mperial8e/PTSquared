//
//  PTClientNavController.h
//  PTSquared
//
//  Created by Kirill on 11/11/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

static NSInteger const PTCNImageTag = 1000;
static NSInteger const PTCNLabelTag = 1001;

@interface PTClientNavController : UINavigationController

- (void)configureNavigationBarItems:(UIViewController *)rootViewController;
- (void)menuButtonPress;
- (void)setTitleImageToNavigationBar:(UIImage *)image;
- (void)setTitleLabelToNavigationBar:(NSString *)titleText;

@end
