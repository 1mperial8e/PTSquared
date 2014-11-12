//
//  PTCMHomeScreenViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTCMHomeScreenViewController.h"
#import "PTClientNavController.h"

@interface PTCMHomeScreenViewController ()

@end

@implementation PTCMHomeScreenViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((PTClientNavController *)self.navigationController) setTitleImageToNavigationBar:[UIImage imageNamedFile:@"22"]];
}

@end
