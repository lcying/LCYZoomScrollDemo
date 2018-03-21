//
//  ViewController.m
//  UICollectionView流动布局
//
//  Created by 刘岑颖 on 2018/3/21.
//  Copyright © 2018年 刘岑颖. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "ZoomFlowLayout.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl * pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self collectionView];
    [self pageControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePageAction:) name:@"CHANGEPAGECONTROLCURRENTINDEX" object:nil];
}

- (void)changePageAction:(NSNotification *)noti{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * 0.5)), dispatch_get_main_queue(), ^{
        NSNumber *number = [noti.userInfo objectForKey:@"index"];
        int index = [number intValue];
        self.pageControl.currentPage = index;
    });
}

#pragma mark - lazy loading -----------------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        ZoomFlowLayout *layout = [[ZoomFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen  mainScreen].bounds.size.width, 300) collectionViewLayout:layout];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 260, [UIScreen mainScreen].bounds.size.width - 20, 20)];
        [self.view addSubview:_pageControl];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor greenColor];
        _pageControl.numberOfPages = 10;
    }
    return _pageControl;
}


#pragma mark - delegate -----------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CollectionViewCell alloc] init];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"第%ld个",indexPath.item];
    return cell;
}

@end
