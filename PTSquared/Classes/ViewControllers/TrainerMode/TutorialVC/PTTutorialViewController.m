//
//  PTTutorialViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTTutorialViewController.h"
#import "PTTutorialCell.h"
#import "PTContainerViewController.h"

static NSString *const PTTCellIdentifier = @"TutorialCell";
static NSInteger const PTTOffcet = 50;

@interface PTTutorialViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, PTTutorialCell>

@property (weak, nonatomic) IBOutlet UICollectionView *tutorialCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;

@property (strong, nonatomic) NSMutableArray *tutorialImages;

@end

@implementation PTTutorialViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureDataSource];
    [self configurePageControl];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
#ifdef __IPHONE_8_0
    self.tutorialCollectionView.layoutMargins = UIEdgeInsetsZero;
#endif
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
    if (indexPath.row == 0){
        cell.skipButton.hidden = NO;
    }
    cell.bounds = self.tutorialCollectionView.frame;
    cell.tutorialImageView.frame = cell.bounds;
    cell.tutorialImageView.image = self.tutorialImages[indexPath.row];
    cell.delegate = self;
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

#pragma mark - PTTutorialCell

- (void)endTutorialConfirmed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

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
        [self.tutorialImages addObject:[UIImage imageNamed:@"11"]];
    }
}

@end