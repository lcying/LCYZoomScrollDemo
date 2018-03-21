//
//  CollectionViewCell.m
//  UICollectionView流动布局
//
//  Created by 刘岑颖 on 2018/3/21.
//  Copyright © 2018年 刘岑颖. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:74/255.0 blue:71/255.0 alpha:1];
        self.layer.cornerRadius = 3.0;
        self.layer.masksToBounds = YES;
        [self titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
