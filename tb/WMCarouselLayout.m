//
//  WMCarouselLayout.m
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "WMCarouselLayout.h"

@interface WMCarouselLayout ()
{
    CGFloat _viewWidth;
    CGFloat _itemWidth;
}

@end

@implementation WMCarouselLayout

- (void)prepareLayout
{
    [super prepareLayout];

    _visibleCount = _visibleCount < 1 ? 5 : _visibleCount;

    _viewWidth = CGRectGetWidth(self.collectionView.frame);
    _itemWidth = _itemSize.width;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewWidth - _itemWidth) / 2, 0, (_viewWidth - _itemWidth) / 2);
}

// 返回size、alpha、scale
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attributes.size = _itemSize;

    CGFloat cX = (self.collectionView.contentOffset.x) + _viewWidth / 2;
    CGFloat attributesX = _itemWidth * indexPath.item + _itemWidth / 2;
    attributes.zIndex = -ABS(attributesX - cX);

    CGFloat delta = cX - attributesX;
    CGFloat ratio = -delta / (_itemWidth * 2);
    CGFloat scale = 1 - ABS(delta) / (_itemWidth * 6.0) * cos(ratio * M_PI_4);

    attributes.alpha = scale;

    attributes.transform = CGAffineTransformMakeScale(scale, scale);

    CGFloat centerX = attributesX;

    attributes.center = CGPointMake(centerX, CGRectGetHeight(self.collectionView.frame) / 2);

    return attributes;
}

// 返回内容尺寸
- (CGSize)collectionViewContentSize
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(cellCount * _itemWidth, CGRectGetHeight(self.collectionView.frame));
}

// 返回一组UICollectionViewLayoutAttributes类型对象
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerX = (self.collectionView.contentOffset.x) + _viewWidth / 2;
    NSInteger index = centerX / _itemWidth;
    NSInteger count = (_visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat index = roundf(((proposedContentOffset.x) + (_viewWidth - _itemWidth) / 2) / _itemWidth);

    //proposedContentOffset.x = _itemWidth * index - (_viewWidth - _itemWidth) / 2;

    if (_carouselLayoutBlock) {
        _carouselLayoutBlock((NSInteger)index);
    }

    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end
