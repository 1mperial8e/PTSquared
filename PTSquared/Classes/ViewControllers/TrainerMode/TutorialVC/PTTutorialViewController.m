//
//  PTTutorialViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTTutorialViewController.h"
#import "PTTutorialCell.h"

static NSString *const PTTCellIdentifier = @"TutorialCell";
static NSInteger const PTTOffcet = 50;

@interface PTTutorialViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *tutorialCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;

@property (strong, nonatomic) NSMutableArray *tutorialImages;

- (void)configureCellSize:(PTTutorialCell*)cell;
- (void)configureDataSource;
- (void)configurePageControl;
- (void)addImagesToDataSource;

@end

@implementation PTTutorialViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureDataSource];
    [self configurePageControl];
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
            cell.skipButton.hidden = !indexPath.row;
            cell.endTutorialButton.hidden = !(indexPath.row == self.tutorialImages.count - 1);
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
    //to add images
}

@end
