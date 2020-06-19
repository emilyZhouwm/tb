//
//  SizeController.h
//  tb
//
//  Created by 周文敏 on 16/6/26.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SizeControllerDelegate<NSObject>

@required
- (void)hideBtnAcion;

@end

@interface SizeController : UIViewController

@property (nonatomic, weak) id <SizeControllerDelegate> delegate;

+ (SizeController *)getVC;

@end
