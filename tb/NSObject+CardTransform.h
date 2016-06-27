//
//  NSObject+CardTransform.h
//  tb
//
//  Created by zwm on 16/6/27.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (CardTransform)

+ (void)showView:(UIView *)toView fromView:(UIView *)fromView completion:(void (^)(BOOL finished))completion;

+ (void)hideView:(UIView *)fromView toView:(UIView *)toView completion:(void (^)(BOOL finished))completion;

@end
