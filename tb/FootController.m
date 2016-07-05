//
//  FootController.m
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "FootController.h"
#import "WMCardScrollView.h"
#import "WMCardView.h"

@interface FootController () <WMCardScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) WMCardScrollView *cardScrollView;

@end

@implementation FootController

+ (void)showFootToVC:(UIViewController *)vc
{
    FootController *footVC = [FootController getVC];
    footVC.view.frame = vc.view.bounds;
    [vc addChildViewController:footVC];
    [vc.view addSubview:footVC.view];
    [footVC showFoot];
}

+ (FootController *)getVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FootController *vc = [sb instantiateViewControllerWithIdentifier:@"FootController"];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    _hideBtn.alpha = 0;

    _cardScrollView = [[WMCardScrollView alloc] initWithFrame:_baseView.bounds];
    _cardScrollView.delegate = self;
    _cardScrollView.backgroundColor = [UIColor clearColor];
    [_baseView addSubview:_cardScrollView];
    [_cardScrollView loadCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WMCardScrollViewDelegate
- (NSInteger)numberOfCards
{
    return 20;
}

- (UIView *)cardReuseView:(UIView *)reuseView atIndex:(NSInteger)index
{
    if (reuseView) {
        return reuseView;
    }
    return [WMCardView cardView];
}

- (void)cardCurrentIndex:(NSInteger)index
{
    _indexLbl.text = [NSString stringWithFormat:@" ( %li / %i )", index + 1, 20];
}

#pragma mark - action
- (IBAction)hideBtnAction:(UIButton *)sender
{
    sender.enabled = FALSE;
    _topLayout.constant = 0;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        _hideBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)showFoot
{
    _topLayout.constant = _headView.frame.size.height;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        _hideBtn.alpha = 1;
    }];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //cell.intrinsicContentSize
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


}

@end
