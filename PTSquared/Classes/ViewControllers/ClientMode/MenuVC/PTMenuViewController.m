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
static NSString *const PTMMenuItemName = @"itemName";
static NSString *const PTMMenuImageName = @"itemImage";

@interface PTMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation PTMenuViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureDataSource];
    [self setTopOffsetForMenu];
    [self setBackgroundForView];
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
    cell.menuTitleUILabel.text = [(NSDictionary *)self.menuItems[indexPath.row] valueForKey:PTMMenuItemName];
    NSString *imageName = [(NSDictionary *)self.menuItems[indexPath.row] valueForKey:PTMMenuImageName];
    cell.imageView.image = [UIImage imageNamedFile:imageName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectMenuItem:indexPath.row];
}

#pragma mark - Private

- (void)configureDataSource
{
    if (!self.menuItems) {
        self.menuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MenuItems" ofType:@"plist"]];
    }
}

- (void)setTopOffsetForMenu
{
    CGFloat offset = self.parentViewController.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.topVerticalSpaceConstraint.constant = offset;
}

- (void)setBackgroundForView
{
    self.view.backgroundColor = UIColorFromRGB(0xB5B5B5);
}

@end
