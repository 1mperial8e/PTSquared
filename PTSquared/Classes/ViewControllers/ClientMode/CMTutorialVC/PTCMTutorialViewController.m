//
//  PTCMTutorialViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTCMTutorialViewController.h"
#import "PTTutorialCell.h"

static NSString *const PTTCellIdentifier = @"TutorialCell";
static NSInteger const PTTOffcet = 50;

@interface PTCMTutorialViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *tutorialCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;

@property (strong, nonatomic) NSMutableArray *tutorialImages;

- (void)configureCellSize:(PTTutorialCell*)cell;
- (void)configureDataSource;
- (void)configurePageControl;
- (void)addImagesToDataSource;

@end

@implementation PTCMTutorialViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureDataSource];
    [self configurePageControl];
    
    self.tutorialCollectionView.contentInset = UIEdgeInsetsZero;

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tutorialCollectionView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tutorialImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PTTutorialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTTCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PTTutorialCell alloc] init];
    }
    [self configureCellSize:(PTTutorialCell*)cell];
    if (indexPath.row) {
        cell.skipButton.hidden = YES;
    }
    cell.tutorialImageView.frame = cell.bounds;
    cell.tutorialImageView.image = self.tutorialImages[indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (NSIndexPath *indexPath in self.tutorialCollectionView.indexPathsForVisibleItems) {
        PTTutorialCell *cell = (PTTutorialCell *)[self.tutorialCollectionView cellForItemAtIndexPath:indexPath];
        if (ABS(cell.frame.origin.x - self.tutorialCollectionView.contentOffset.x) <= PTTOffcet) {
            self.tutorialPageControl.currentPage = indexPath.row;
            cell.skipButton.hidden = indexPath.row == 0 ? NO : YES;
            cell.endTutorialButton.hidden = indexPath.row == self.tutorialImages.count - 1 ? NO : YES;
        }
    }
}

#pragma mark - Private

- (void)configureCellSize:(PTTutorialCell*)cell
{
    cell.bounds = self.tutorialCollectionView.bounds;
}

- (void)configureDataSource
{
    if (!self.tutorialImages) {
        self.tutorialImages = [[NSMutableArray alloc] init];
    }
    [self addImagesToDataSource];
}

- (void)configurePageControl
{
    if (self.tutorialImages.count) {
        self.tutorialPageControl.numberOfPages = self.tutorialImages.count;
    } else {
        self.tutorialPageControl.numberOfPages = 0;
    }
}

- (void)addImagesToDataSource
{
    for (int i = 0; i < 4; i++) {
        [self.tutorialImages addObject:[UIImage imageWithColor:[UIColor colorWithRed:10*i/255.0 green:10+20*i/255.0 blue:70/255.0 alpha:1.0f]]];
    }
}

@end