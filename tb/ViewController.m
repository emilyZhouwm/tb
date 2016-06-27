//
//  ViewController.m
//  tb
//
//  Created by 周文敏 on 16/6/25.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "ViewController.h"
#import "SizeController.h"
#import "NSObject+CardTransform.h"

@interface ViewController () <SizeControllerDelegate>
{
    CGFloat _alpha;
    CGFloat _alphaCur;
    BOOL _isDetail;
    BOOL _isDetailFromRight;
}

@property (strong, nonatomic) SizeController *vc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTopLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *headLine;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailTipLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTipTopLayout;
@property (weak, nonatomic) IBOutlet UILabel *rightTipLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTipLeftLayout;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _rightTipLbl.text = @"滑\n动\n查\n看\n图\n文\n详\n情";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _backScrollView) {
        if (scrollView.contentOffset.y > 0) {
            _headTopLayout.constant = scrollView.contentOffset.y * 0.5;
        } else {
            _headTopLayout.constant = 0;
        }
        if (scrollView.contentOffset.y > _headScrollView.frame.size.height - 64) {
            _alpha = 1;
            [self changeNav];
        } else if (scrollView.contentOffset.y >= 0) {
            _alpha = scrollView.contentOffset.y / (_headScrollView.frame.size.height - 64);
            [self changeNav];
        }
        if (!_isDetail) {
            if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
                _topLayout.constant = -(scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height);
            } else {
                _topLayout.constant = 0;
            }
        }
    } else if (scrollView == _headScrollView) {
        if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width) {
            _rightTipLeftLayout.constant = 15 - (scrollView.contentOffset.x + scrollView.frame.size.width - scrollView.contentSize.width);
        } else {
            _rightTipLeftLayout.constant = 15;
        }
        if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width + 40) {
            _rightTipLbl.text = @"释\n放\n查\n看\n图\n文\n详\n情";
        } else {
            _rightTipLbl.text = @"滑\n动\n查\n看\n图\n文\n详\n情";
        }
    } else if (scrollView == _detailScrollView) {
        if (!_isDetailFromRight) {
            if (scrollView.contentOffset.y < 0) {
                if (scrollView.contentOffset.y < -30) {
                    _detailTipLbl.alpha = 1;
                } else {
                    _detailTipLbl.alpha = -scrollView.contentOffset.y / 30.0f;
                }
            } else {
                _detailTipLbl.alpha = 0;
            }
            if (scrollView.contentOffset.y < -40) {
                _detailTipLbl.text = @"释放，返回宝贝详情";
                _detailTipTopLayout.constant = 55 - 40 - scrollView.contentOffset.y;
            } else {
                _detailTipLbl.text = @"下拉，返回宝贝详情";
                _detailTipTopLayout.constant = 55;
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _backScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height > 40) {
            [self showDetail];
        }
    } else if (scrollView == _detailScrollView) {
        if (_isDetail && scrollView.contentOffset.y < -40) {
            [self hideDetail];
        }
    } else if (scrollView == _headScrollView) {
        if (scrollView.contentOffset.x + scrollView.frame.size.width - scrollView.contentSize.width > 40) {
            [self showDetailFromRight];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _headScrollView) {
        _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

#pragma mark - private
- (void)showDetailFromRight
{
    if (_isDetailFromRight) {
        return;
    }
    _detailView.hidden = FALSE;
    _isDetailFromRight = TRUE;
    _topLayout.constant = -(_detailScrollView.frame.size.height + 40);
    _leftLayout.constant = self.view.frame.size.width;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    _leftLayout.constant = 0;
    [self.view setNeedsLayout];
    _alpha = 1;
    _detailTipLbl.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self changeNav];
        _backBtn.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideDetailToRight
{
    if (!_isDetailFromRight) {
        return;
    }
    _isDetailFromRight = FALSE;
    _leftLayout.constant = self.view.frame.size.width;
    _alpha = 0;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self changeNav];
        _backBtn.alpha = 0;
    } completion:^(BOOL finished) {
        _topLayout.constant = 0;
        _leftLayout.constant = 0;
    }];
}

- (void)showDetail
{
    if (_isDetail) {
        return;
    }
    _detailView.hidden = FALSE;
    _isDetail = TRUE;
    _topLayout.constant = 0;
    _bottomLayout.priority = 249;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideDetail
{
    if (!_isDetail) {
        return;
    }
    _isDetail = FALSE;
    _bottomLayout.priority = 750;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)changeNav
{
    if (_alphaCur == _alpha) {
        return;
    }
    _alphaCur = _alpha;
    _headView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:_alphaCur];
    _headLine.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:_alphaCur];
}

#pragma mark - action
- (IBAction)backBtnAction:(UIButton *)sender
{
    [self hideDetailToRight];
}

- (IBAction)sizeBtnAction:(UIButton *)sender
{
    _vc = [SizeController getVC];
    _vc.delegate = self;

    [NSObject showView:_vc.view fromView:self.view completion:nil];
}

- (void)hideBtnAcion
{
    [NSObject hideView:_vc.view toView:self.view completion:^(BOOL finished) {
        [_vc.view removeFromSuperview];
        _vc = nil;
    }];
}

@end
