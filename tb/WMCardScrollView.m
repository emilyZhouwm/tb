//
//  WMCardScrollView.h
//  tb
//
//  Created by zwm on 16/6/28.
//  Copyright © 2016年 周文敏. All rights reserved.
//

#import "WMCardScrollView.h"

#define kViewWidth CGRectGetWidth(self.frame)
#define kViewHeight CGRectGetHeight(self.frame)

#define kScrollViewWidth kViewWidth * 0.4
#define kScrollViewHeight kViewHeight

#define kCardWidth kViewWidth * 0.4
#define kCardHeight kViewHeight

@interface WMCardScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollView2;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, assign) NSInteger totals;
@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation WMCardScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScrollViewWidth, kScrollViewHeight)];
    _scrollView.center = CGPointMake(kViewWidth / 2, kViewHeight / 2);
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];

    _scrollView2 = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView2.delegate = self;
    _scrollView2.pagingEnabled = YES;
    _scrollView2.showsVerticalScrollIndicator = NO;
    _scrollView2.showsHorizontalScrollIndicator = NO;
    _scrollView2.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView2];

    _cards = @[].mutableCopy;
    _curIndex = 0;
}

- (void)loadCard
{
    for (UIView *card in _cards) {
        [card removeFromSuperview];
    }
    [_cards removeAllObjects];

    _totals = [_delegate numberOfCards];
    if (_totals == 0) {
        return;
    }

    [_scrollView setContentSize:CGSizeMake(kScrollViewWidth * _totals, kScrollViewHeight)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];

    [_scrollView2 setContentSize:CGSizeMake(kViewWidth * _totals, kViewHeight)];
    [_scrollView2 setContentOffset:CGPointMake(0, 0)];

    for (NSInteger index = 0; index < (_totals < 4 ? _totals : 4); index++) {
        UIView *card = [_delegate cardReuseView:nil atIndex:index];
        card.frame = CGRectMake(0, 0, kCardWidth, kCardHeight);
        card.center = [self centerForCardWithIndex:index];
        card.tag = index;

        [_scrollView addSubview:card];
        [_cards addObject:card];

        [self updateCard:card withProgress:1 direction:WMCardMoveNone];
    }
}

- (NSInteger)currentIndex
{
    return _curIndex;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        CGFloat orginContentOffset = _curIndex * kScrollViewWidth;
        CGFloat diff = scrollView.contentOffset.x - orginContentOffset;
        CGFloat progress = fabs(diff) / (kViewWidth * 0.5);
        WMCardMoveDir direction = diff > 0 ? WMCardMoveLeft : WMCardMoveRight;
        for (UIView *card in _cards) {
            [self updateCard:card withProgress:progress direction:direction];
        }

        if (fabs(diff) >= kScrollViewWidth * 0.5) {
            _curIndex = direction == WMCardMoveLeft ? _curIndex + 1 : _curIndex - 1;
            [_delegate cardCurrentIndex:_curIndex];
            [self reuseCardWithMoveDirection:direction];
        }
    } else {
        _scrollView.contentOffset = CGPointMake(_scrollView2.contentOffset.x * kScrollViewWidth / kViewWidth, 0);
    }
}

#pragma mark - private
- (void)updateCard:(UIView *)card withProgress:(CGFloat)progress direction:(WMCardMoveDir)direction
{
    if (direction == WMCardMoveNone) {
        if (card.tag != _curIndex) {
            CGFloat scale = 1 - 0.2 * progress;
            [self scaleCard:card withScale:scale];

            card.alpha = 1 - 0.3 * progress;
        } else {
            [self scaleCard:card withScale:1];
            card.alpha = 1;
        }
    } else {
        NSInteger transCardTag = direction == WMCardMoveLeft ? _curIndex + 1 : _curIndex - 1;
        if (card.tag != _curIndex && card.tag == transCardTag) {
            CGFloat scale = 0.8 + 0.2 * progress;
            [self scaleCard:card withScale:scale];

            card.alpha = 0.7 + 0.3 * progress;
        } else if (card.tag == _curIndex) {
            CGFloat scale = 1 - 0.2 * progress;
            [self scaleCard:card withScale:scale];

            card.alpha = 1 - 0.3 * progress;
        }
    }
}

- (void)scaleCard:(UIView *)card withScale:(CGFloat)scale
{
    CGRect frame = card.frame;
    frame.size.width = kCardWidth * scale;
    frame.size.height = kCardHeight * scale;
    card.frame = frame;
    card.center = [self centerForCardWithIndex:card.tag];
}

- (void)reuseCardWithMoveDirection:(WMCardMoveDir)moveDirection
{
    BOOL isLeft = moveDirection == WMCardMoveLeft;
    UIView *card = nil;
    if (isLeft) {
        if (_curIndex > _totals - 3 || _curIndex < 2) {
            return;
        }
        card = [_cards objectAtIndex:0];
        card.tag += 4;
    } else {
        if (_curIndex > _totals - 4 ||
            _curIndex < 1) {
            return;
        }
        card = [_cards objectAtIndex:3];
        card.tag -= 4;
    }
    card.center = [self centerForCardWithIndex:card.tag];
    [_delegate cardReuseView:card atIndex:card.tag];
    [self ascendingSortCards];
}

- (void)ascendingSortCards
{
    [_cards sortUsingComparator:^NSComparisonResult (UIView *obj1, UIView *obj2) {
        return obj1.tag > obj2.tag;
    }];
}

- (CGPoint)centerForCardWithIndex:(NSInteger)index
{
    return CGPointMake(kScrollViewWidth * (index + 0.5), _scrollView.center.y);
}

@end
