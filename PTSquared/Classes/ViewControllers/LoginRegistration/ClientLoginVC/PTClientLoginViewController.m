//
//  PTClientLoginViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTClientLoginViewController.h"

@interface PTClientLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation PTClientLoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)restorePassButtonPress:(id)sender
{
    
}

- (IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
