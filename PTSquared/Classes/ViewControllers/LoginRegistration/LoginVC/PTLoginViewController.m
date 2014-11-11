//
//  PTLoginViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTLoginViewController.h"

@interface PTLoginViewController ()

@end

@implementation PTLoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavigationController];
}

#pragma mark - Private

- (void)configureNavigationController
{
    [self.navigationController setNavigationBarHidden:YES];
}

@end
