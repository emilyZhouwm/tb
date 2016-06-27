//
//  SizeController.m
//  tb
//
//  Created by 周文敏 on 16/6/26.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "SizeController.h"

@interface SizeController ()

@property (weak, nonatomic) IBOutlet UIView *thumbnailView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImg;

@end

@implementation SizeController

+ (SizeController *)getVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SizeController *vc = [sb instantiateViewControllerWithIdentifier:@"SizeController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _thumbnailImg.layer.cornerRadius = 4;
    _thumbnailImg.layer.masksToBounds = YES;
    _thumbnailView.layer.cornerRadius = 4;
    _thumbnailView.layer.masksToBounds = YES;
    _thumbnailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _thumbnailView.layer.borderWidth = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideBtnAction:(UIButton *)sender
{
    if (_delegate) {
        [_delegate hideBtnAcion];
    }
}

@end
