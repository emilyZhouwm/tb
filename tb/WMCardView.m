//
//  WMCardView.m
//  tb
//
//  Created by zwm on 16/7/5.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "WMCardView.h"

@implementation WMCardView

+ (WMCardView *)cardView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WMCardView" owner:self options:nil];
    WMCardView *cardView = [nibs lastObject];
    return cardView;
}

@end
