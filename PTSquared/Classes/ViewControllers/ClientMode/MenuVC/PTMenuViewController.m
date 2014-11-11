//
//  PTMenuViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTMenuViewController.h"
#import "PTMenuTableViewCell.h"

static NSString *const PTMCellIdentifier = @"menuCell";

@interface PTMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVerticalSpaceConstraint;

@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation PTMenuViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureDataSource];
    [self setTopOffsetForMenu];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PTMCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PTMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PTMCellIdentifier];
    }
    cell.menuTitleUILabel.text = self.menuItems[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Private

- (void)configureDataSource
{
    if (!self.menuItems) {
        self.menuItems = @[@"HOME", @"CALENDAR", @"WORKOUT", @"NUTRITION", @"PROFILE", @"LOGOUT"];
    }
}

- (void)setTopOffsetForMenu
{
    CGFloat offset = self.parentViewController.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.topVerticalSpaceConstraint.constant = offset;
}

@end
