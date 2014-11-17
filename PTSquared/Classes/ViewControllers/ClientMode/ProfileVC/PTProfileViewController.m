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

static NSString *const PTPCellIdentifier = @"ProfileCell";
static NSString *const PTPCellImageIdentifier = @"ProfileCellImage";
static NSInteger const sizeCell = 45;
static NSInteger const sizeCellImage = 200;

static CGFloat const sectionHeaderHeight = 30;
static CGFloat const sectionViewHeight = 25;

@interface PTProfileViewController ()

@property (strong, nonatomic) NSArray *arrayProfile;

@end

@implementation PTProfileViewController


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *strJSON = @"{\"Profile\":[{\"Height & Weight\":[{\"6 foot 2 inches\":\"70 kg\"}]},{\"Body Mass Index\":[\"22.5\"]},{\"Key Body Measurements\":[{\"Upper arm\":\"16 inches\"}, {\"Abdomen\":\"25 inches\"} , {\"Waist\":\"32 inches\"}]},{\"Skin Folds\":[{\"Chest\":\"80mm\"},{\"Abdomen\":\"120mm\"},{\"Thigh\":\"80mm\"},{\"Triceps\":\"80mm\"},{\"Axilla\":\"80mm\"}]},{\"Client Since\":[\"9th of September, 2014\"]},{\"Goal\":[\"<Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal Personal Goal >\"]},{\"Before & After\" :[[\"before\",\"After\"]]}]}";
    
    NSData *jsonData = [strJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *JsonDiction = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    self.arrayProfile = [JsonDiction allValues][0];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.separatorColor = UIColorFromRGB(0x9D9D9D);
    tableView.sectionHeaderHeight = sectionHeaderHeight;
    return [self.arrayProfile count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionaryArrayCells = self.arrayProfile[section];
    NSArray *arrayCells = [dictionaryArrayCells allValues][0];
    return [arrayCells count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section<[self.arrayProfile count] - 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:PTPCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *cellsDictionary = self.arrayProfile[indexPath.section];
        NSArray *cellsArray = [cellsDictionary allValues][0];
        NSDictionary *cellDictionary = cellsArray[indexPath.row];
        if ([cellDictionary isKindOfClass:[NSDictionary class]]) {
            cell.textLabel.text = [cellDictionary allKeys][0];
            cell.detailTextLabel.text = [cellDictionary allValues][0];
        }else{
            cell.textLabel.text = cellsArray[indexPath.row];
            [cell.textLabel sizeToFit];
            cell.detailTextLabel.hidden = YES;
        }
        cell.backgroundColor = UIColorFromRGB(0x9D9D9D);
    } else {
       cell = [tableView dequeueReusableCellWithIdentifier:PTPCellImageIdentifier forIndexPath:indexPath];
        ((PTPersonalImageProfileCell *)cell).personalImageBefore.image = [UIImage imageNamedFile:@"11"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PTHeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    if (!headerView) {
        headerView = [[PTHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
    }
    NSDictionary *sectionNameDictionary = self.arrayProfile[section];
    headerView.nameSectionLabel.text = [sectionNameDictionary allKeys][0];
    headerView.backgroundColor = UIColorFromRGB(0x9D9D9D);
    if (section == [self.arrayProfile count]-1) {
        headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return sectionViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = sizeCell;
    if (indexPath.section==[self.arrayProfile count]-1)
    {
        size = sizeCellImage;
    }else if (indexPath.section == [self.arrayProfile count]-2) {
        return UITableViewAutomaticDimension;
    }
    return size;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


@end
