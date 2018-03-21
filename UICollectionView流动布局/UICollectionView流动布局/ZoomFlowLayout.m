//
//  ZoomFlowLayout.m
//  UICollectionView流动布局
//
//  Created by 刘岑颖 on 2018/3/21.
//  Copyright © 2018年 刘岑颖. All rights reserved.
//

#import "ZoomFlowLayout.h"

@implementation ZoomFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    //设置item的属性
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 150);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat insert = (self.collectionView.frame.size.width - self.itemSize.width) / 2.0;
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
    self.minimumLineSpacing = 10;
}

/** 设置停止的时候中心的那个item
 *  只要手一松开就会调用
 *  这个方法的返回值，就决定了CollectionView停止滚动时的偏移量
 *  proposedContentOffset这个是最终的 偏移量的值 但是实际的情况还是要根据返回值来定
 *  velocity  是滚动速率  有个x和y 如果x有值 说明x上有速度
 *  如果y有值 说明y上又速度 还可以通过x或者y的正负来判断是左还是右（上还是下滑动）  有时候会有用
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //得到当前显示区域
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    //得到显示区域的中心点
    CGFloat centerX = self.collectionView.frame.size.width / 2.0 + proposedContentOffset.x;
    
    //当前显示区域的所有attributes
    NSArray *array = [self layoutAttributesForElementsInRect:rect];
    
    CGFloat minDelta = MAXFLOAT;
    //找到距离中心点最近的item的center.x和centerX的差值
    
    int currentIndex = 0;//记录当前最近的item的下标
    for (int i = 0; i < array.count; i ++) {
        UICollectionViewLayoutAttributes *attrs = [array objectAtIndex:i];
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
            currentIndex = i;
        }
    }
    
    UICollectionViewLayoutAttributes *currentArr = [array objectAtIndex:currentIndex];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEPAGECONTROLCURRENTINDEX" object:nil userInfo:@{@"index" : @(currentArr.indexPath.item)}];
    
    //修改原有的偏移量使得距离中心点最近的一个item能够滑动到中心位置
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
}

/** 缩放操作 -------------
 *  这个方法的返回值是一个数组(数组里存放在rect范围内所有元素的布局属性)
 *  这个方法的返回值  决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //获得super已经计算好的布局属性 只有线性布局才能使用
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //得到collectionView中心点
    CGFloat centerX = self.collectionView.frame.size.width / 2.0 + self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat delta = ABS(attrs.center.x - centerX);
        
        CGFloat scale = 1 - (delta / self.collectionView.frame.size.width) * 0.2;
        //有make表示根据对象最原始的状态进行变化；没有表示根据变化过的状态进行变化
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}

/*!
 *  多次调用 只要滑出范围就会 调用
 *  当CollectionView的显示范围发生改变的时候，是否重新发生布局
 *  一旦重新刷新 布局，就会重新调用
 *  1.layoutAttributesForElementsInRect：方法
 *  2.preparelayout方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
