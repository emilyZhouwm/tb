//
//  UIView+CardTransform.h
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CardTransform)

- (void)showCard:(UIView *)cardView completion:(void (^)(BOOL finished))completion;

- (void)hideCard:(UIView *)cardView completion:(void (^)(BOOL finished))completion;

@end
