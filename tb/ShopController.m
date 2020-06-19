//
//  ShopController.m
//  tb
//
//  Created by 周文敏 on 16/6/26.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "ShopController.h"

@interface ShopController ()
{
    CGFloat _progress;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftLayout;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *headView;

@end

@implementation ShopController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _headView = _tableView.tableFooterView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self setHeadColor:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 130) {
        if (scrollView.contentOffset.y < 150) {
            CGFloat progress = (scrollView.contentOffset.y - 130) / 20;
            if (_progress != progress) {
                _progress = progress;
                [self setHeadStatus];
            }
        } else if (_progress != 1) {
            _progress = 1;
            [self setHeadStatus];
        }
    } else if (_progress != 0) {
        _progress = 0;
        [self setHeadStatus];
    }
}

#pragma mark - action
- (IBAction)headBtnAction:(UIButton *)sender
{
    [self setHeadColor:sender.tag - 1001];
    _lineLeftLayout.constant = (sender.tag - 1001) * self.view.frame.size.width / 4;
    [_lineView setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [_lineView layoutIfNeeded];
    }];
}

#pragma mark - private
- (void)setHeadColor:(NSInteger)index
{
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backView = [_headView viewWithTag:2001 + i];

        UIColor *color = i == index ? [UIColor colorWithRed:224/255.0 green:100/255.0 blue:0 alpha:1] : [UIColor grayColor];
        UIImageView *image = [backView viewWithTag:1];
        [image setTintColor:color];
        UILabel *label = [backView viewWithTag:2];
        [label setTextColor:color];
    }
}

- (void)setHeadStatus
{
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backView = [_headView viewWithTag:2001 + i];

        UIImageView *image = [backView viewWithTag:1];
        [image setAlpha:1 - _progress];
        UILabel *label = [backView viewWithTag:2];
        [label setFont:[UIFont systemFontOfSize:10 + 5 * _progress]];

        for (NSLayoutConstraint *con in label.constraints) {
            if (con.identifier.length > 0) {
                con.constant = 30 + 10 * _progress;
                break;
            }
        }
    }
}

@end
