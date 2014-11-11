//
//  PTClientScreenViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTClientScreenViewController.h"

@interface PTClientScreenViewController ()

@end

@implementation PTClientScreenViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
