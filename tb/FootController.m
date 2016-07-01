//
//  FootController.m
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "FootController.h"
#import "WMCarouselLayout.h"

@interface FootController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *indexLbl;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    WMCarouselLayout *layout = [[WMCarouselLayout alloc] init];
//    __weak typeof (self) weakSelf = self;
//    layout.carouselLayoutBlock = ^(NSInteger index){
//        weakSelf.indexLbl.text = [NSString stringWithFormat:@" ( %li / %i )", index + 1, 20];
//    };
//    layout.itemSize = CGSizeMake(_collectionView.frame.size.width * 3 / 10, _collectionView.frame.size.height);
//    _collectionView.collectionViewLayout = layout;

    CGFloat w = _collectionView.frame.size.height * 2 / 3;
    UICollectionViewLayout *lt = [[UICollectionViewLayout alloc] init];
    //lt.itemSize = CGSizeMake(w, _collectionView.frame.size.height);
    _collectionView.collectionViewLayout = lt;
    _collectionView.contentInset = UIEdgeInsetsMake(0, (_collectionView.frame.size.width - w) / 2, 0, (_collectionView.frame.size.width - w) / 2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
