//
//  WMCarouselLayout.h
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WMCarouselLayoutBlock)(NSInteger index);

@interface WMCarouselLayout : UICollectionViewLayout

@property (nonatomic, copy) WMCarouselLayoutBlock carouselLayoutBlock;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) CGSize itemSize;

@end
