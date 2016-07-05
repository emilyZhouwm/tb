//
//  WMCardScrollView.h
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, WMCardMoveDir) {
    WMCardMoveNone,
    WMCardMoveLeft,
    WMCardMoveRight
};

@protocol WMCardScrollViewDelegate <NSObject>

- (NSInteger)numberOfCards;
- (UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index;
- (void)cardCurrentIndex:(NSInteger)index;

@end

@interface WMCardScrollView : UIView

@property (nonatomic, weak) id<WMCardScrollViewDelegate> delegate;

- (void)loadCard;
- (NSInteger)currentIndex;

@end
