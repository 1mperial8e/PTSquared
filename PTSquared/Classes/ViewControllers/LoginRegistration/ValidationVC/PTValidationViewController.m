//
//  PTValidationViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTValidationViewController.h"

@interface PTValidationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *validationCodeTextField;

@end

@implementation PTValidationViewController

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

- (IBAction)cancelButtonPress:(id)sender
{
    
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
