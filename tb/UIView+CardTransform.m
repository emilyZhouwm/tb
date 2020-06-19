//
//  UIView+CardTransform.m
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "UIView+CardTransform.h"

@implementation UIView (CardTransform)

- (void)showCard:(UIView *)cardView completion:(void (^)(BOOL finished))completion
{
    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height;
    cardView.frame = frame;
    frame.origin.y = 0;
    [[[UIApplication sharedApplication].windows firstObject] addSubview:cardView];

    CATransform3D t1 = [self firstTransform];
    CATransform3D t2 = [self secondTransformWithView:self];

    [UIView animateKeyframesWithDuration:0.8f
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.1f relativeDuration:0.5f animations:^{
            self.layer.transform = t1;
            self.alpha = 0.6;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
            self.layer.transform = t2;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
            cardView.frame = frame;
        }];
    } completion:completion];
}

- (void)hideCard:(UIView *)cardView completion:(void (^)(BOOL finished))completion
{
    CGRect frame = cardView.frame;
    self.frame = frame;
    CATransform3D t2 = [self secondTransformWithView:cardView];
    self.layer.transform = t2;
    self.alpha = 0.6;

    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;

    CATransform3D t1 = [self firstTransform];

    [UIView animateKeyframesWithDuration:0.8f
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.8f animations:^{
            cardView.frame = frameOffScreen;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.2f animations:^{
            self.layer.transform = t1;
            self.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.5f animations:^{
            self.layer.transform = CATransform3DIdentity;
        }];
    } completion:completion];
}

- (CATransform3D)firstTransform
{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
}

- (CATransform3D)secondTransformWithView:(UIView *)view
{
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0 / -900;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height* -0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);

    return t2;
}

@end
