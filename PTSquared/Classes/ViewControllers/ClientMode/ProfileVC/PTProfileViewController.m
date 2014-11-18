//
//  PTProfileViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTProfileViewController.h"
#import "PTPersonalImageProfileCell.h"
#import "PTHeaderTableViewCell.h"
#import "PTGoalsTableViewCell.h"
#import "PTGenericProfileTableViewCell.h"

static NSString *const PTPCellIdentifier = @"ProfileCell";
static NSString *const PTPCellImageIdentifier = @"ProfileCellImage";
static NSString *const PTPCellGoalsIdentifier = @"goalCell";
static NSString *const PTPCellFooterIdentifier = @"footerCell";
static NSString *const PTPCellHeaderIdentifier = @"headerCell";

static NSInteger const PTPSizeCell = 45;
static NSInteger const PTPSizeCellImage = 138;
static CGFloat const PTPSectionHeaderHeight = 47;
static CGFloat const PTPFooterHeight = 10;

@interface PTProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (strong, nonatomic) NSArray *profileDataSource;

@end

@implementation PTProfileViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureDataSource];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.profileTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.profileDataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionaryArrayCells = self.profileDataSource[section];
    NSArray *arrayCells = [dictionaryArrayCells allValues][0];
    return [arrayCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    //TODO - change dataSource add method for dataSource
    NSDictionary *cellsDictionary = self.profileDataSource[indexPath.section];
    NSArray *cellsArray = [cellsDictionary allValues][0];
    NSDictionary *cellDictionary = cellsArray[indexPath.row];
    
    if (indexPath.section < [self.profileDataSource count] - 1) {
        if ([cellDictionary isKindOfClass:[NSDictionary class]]) {
            cell = [tableView dequeueReusableCellWithIdentifier:PTPCellIdentifier forIndexPath:indexPath];
            ((PTGenericProfileTableViewCell *)cell).titleProfileLabel.text = [cellDictionary allKeys][0];
            ((PTGenericProfileTableViewCell *)cell).detailedProfileLabel.text = [cellDictionary allValues][0];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:PTPCellGoalsIdentifier forIndexPath:indexPath];
            cell = [self configureCell:(PTGoalsTableViewCell *)cell forIndexpath:indexPath];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:PTPCellImageIdentifier forIndexPath:indexPath];
        cell = [self configureImageCell:(PTPersonalImageProfileCell *)cell forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PTHeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:PTPCellHeaderIdentifier];
    if (!headerView) {
        headerView = [[PTHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PTPCellHeaderIdentifier];
    }
    NSDictionary *sectionNameDictionary = self.profileDataSource[section];
    headerView.nameSectionLabel.text = [sectionNameDictionary allKeys][0];
    if (section == [self.profileDataSource count] - 1) {
        headerView.backgroundColor = RGBA(181, 181, 181, 0.25);
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PTPSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *footerCell = [tableView dequeueReusableCellWithIdentifier:PTPCellFooterIdentifier];
    if (!footerCell) {
        footerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PTPCellFooterIdentifier];
    }
    return footerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return PTPFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = PTPSizeCell;
    if (indexPath.section == [self.profileDataSource count] - 1) {
        size = PTPSizeCellImage;
    } else if (indexPath.section == [self.profileDataSource count] - 2) {
        return [self heightForImageCellAtIndexPath:indexPath];
    }
    return size;
}

#pragma mark - DynamicHeightOfCell

- (PTGoalsTableViewCell *)configureCell:(PTGoalsTableViewCell *)cell forIndexpath:(NSIndexPath *)indexPath
{
    NSDictionary *cellsDictionary = self.profileDataSource[indexPath.section];
    NSArray *cellsArray = [cellsDictionary allValues][0];
    cell.goalsLabel.text = cellsArray[indexPath.row];
    cell.goalsLabel.numberOfLines = 0;
    
    return cell;
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *) indexPath
{
    static PTGoalsTableViewCell *sizingCell = nil;
    static dispatch_once_t  token;
    dispatch_once(&token, ^ {
        sizingCell = [self.profileTableView dequeueReusableCellWithIdentifier:PTPCellGoalsIdentifier];
    });
    [self configureCell:sizingCell forIndexpath:indexPath];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.profileTableView.bounds), 0.0f);
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - Private

- (void)configureDataSource
{
    NSString *strJSON = @"{\"Profile\":[{\"Height & Weight\":[{\"6 foot 2 inches\":\"70 kg\"}]},{\"Body Mass Index\":[\"22.5\"]},{\"Key Body Measurements\":[{\"Upper arm\":\"16 inches\"}, {\"Abdomen\":\"25 inches\"} , {\"Waist\":\"32 inches\"}]},{\"Skin Folds\":[{\"Chest\":\"80mm\"},{\"Abdomen\":\"120mm\"},{\"Thigh\":\"80mm\"},{\"Triceps\":\"80mm\"},{\"Axilla\":\"80mm\"}]},{\"Client Since\":[\"9th of September, 2014\"]},{\"Goal\":[\"<Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal >\"]},{\"Before & After\" :[[\"before\",\"After\"]]}]}";
    
    NSData *jsonData = [strJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    self.profileDataSource = [jsonDictionary allValues][0];
}

- (void)configureTableView
{
    self.profileTableView.backgroundColor = [UIColor colorFromImage:@"11"];
}

- (PTPersonalImageProfileCell *)configureImageCell:(PTPersonalImageProfileCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.personalImageBefore.image = [UIImage imageNamedFile:@"11"];
    cell.personalImageAfter.image = [UIImage imageNamedFile:@"22"];
    
    cell.personalImageAfter = [self setCornerRadiusForImage:cell.personalImageAfter];
    cell.personalImageBefore = [self setCornerRadiusForImage:cell.personalImageBefore];

    return cell;
}

- (UIImageView *)setCornerRadiusForImage:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = 16.0f;
    imageView.layer.backgroundColor = [UIColor grayColor].CGColor;
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.masksToBounds = YES;
    return imageView;
}

@end
