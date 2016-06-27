//
//  NSObject+CardTransform.m
//  tb
//
//  Created by zwm on 16/6/27.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "NSObject+CardTransform.h"

@implementation NSObject (CardTransform)

+ (void)showView:(UIView *)toView fromView:(UIView *)fromView completion:(void (^)(BOOL finished))completion
{
    CGRect frame = fromView.bounds;
    frame.origin.y = frame.size.height;
    toView.frame = frame;
    frame.origin.y = 0;
    [[[UIApplication sharedApplication].windows firstObject] addSubview:toView];

    CATransform3D t1 = [NSObject firstTransform];
    CATransform3D t2 = [NSObject secondTransformWithView:fromView];

    [UIView animateKeyframesWithDuration:0.8f
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.3f relativeDuration:0.5f animations:^{
            fromView.layer.transform = t1;
            fromView.alpha = 0.6;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4f relativeDuration:0.4f animations:^{
            fromView.layer.transform = t2;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.1f animations:^{
            toView.frame = CGRectOffset(toView.frame, 0.0, -10.0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1f relativeDuration:0.9f animations:^{
            toView.frame = frame;
        }];
    } completion:completion];
}

+ (void)hideView:(UIView *)fromView toView:(UIView *)toView completion:(void (^)(BOOL finished))completion
{
    CGRect frame = fromView.frame;
    toView.frame = frame;
    CATransform3D t2 = [NSObject secondTransformWithView:fromView];
    toView.layer.transform = t2;
    toView.alpha = 0.6;

    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;

    CATransform3D t1 = [NSObject firstTransform];

    [UIView animateKeyframesWithDuration:0.8f
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.8f animations:^{
            fromView.frame = frameOffScreen;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.2f animations:^{
            toView.layer.transform = t1;
            toView.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.5f animations:^{
            toView.layer.transform = CATransform3DIdentity;
        }];
    } completion:completion];
}

+ (CATransform3D)firstTransform
{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
}

+ (CATransform3D)secondTransformWithView:(UIView *)view
{
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0 / -900;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height* -0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);

    return t2;
}

@end
