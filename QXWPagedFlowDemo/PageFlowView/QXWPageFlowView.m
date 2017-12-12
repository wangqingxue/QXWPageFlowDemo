//
//  PageFlowView.m
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2017/12/9.
//  Copyright © 2017年 王庆学. All rights reserved.
//

#import "QXWPageFlowView.h"

@interface QXWPageFlowView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, assign) NSInteger originCount;

@property (nonatomic, assign) CGSize pageSize;

@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, strong) NSMutableArray *visiableCells;

@end

@implementation QXWPageFlowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self Initialize];
    }
    return self;
}

- (void)Initialize{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
}

- (void)reloadData{
    if ([_dateSource respondsToSelector:@selector(pageFlowScrollViewPageCount)]){
        _originCount = [_dateSource pageFlowScrollViewPageCount];
        _pageCount = _originCount * 3;
    }
    for (int i = 0; i < _pageCount; i++){
        [self.cells addObject:[NSNull null]];
    }
    if ([_dateSource respondsToSelector:@selector(pageFlowPageSizeFromScrollView)]){
        _pageSize = [_dateSource pageFlowPageSizeFromScrollView];
    }
    self.scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, 0);
    [self.scrollView setContentOffset:CGPointMake(_pageSize.width * _originCount, 0) animated:NO];
    [self calculaterStartPointAndEndPointWith:CGPointMake(_pageSize.width * _originCount, 0)];
}

- (void)calculaterStartPointAndEndPointWith:(CGPoint)contentOffsetPoint{
    CGFloat startX = contentOffsetPoint.x - [UIScreen mainScreen].bounds.size.width;
    CGFloat endX = contentOffsetPoint.x + [UIScreen mainScreen].bounds.size.width;
    NSInteger startIndex,endIndex;
    for (int i = 0; i < _pageCount; i++){
        if ((i + 1) * _pageSize.width > startX){
            startIndex = i;
            break;
        }
    }
    for (int i = startIndex; i < _pageCount; i++){
        if (((i + 1) * _pageSize.width > endX) && (i * _pageSize.width < endX)){
            endIndex = i;
        } 
    }
    NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
    [self setCellFrameWithCGRect:range];
}


- (void)setCellFrameWithCGRect:(NSRange)rect{
    [self.visiableCells removeAllObjects];
    for (int i = (int)rect.location; i < rect.location + rect.length; i++){
        UIView *view = [_dateSource pageFlowViewWithIndex:i];
        view.frame = CGRectMake(i * _pageSize.width,0,_pageSize.width,_pageSize.height);
        [self.scrollView addSubview:view];
        [self.visiableCells addObject:view];
    };
    [self setVisibableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self calculaterStartPointAndEndPointWith:scrollView.contentOffset];
}

- (void)setVisibableView{
    for (UIView *view in self.visiableCells){
        NSLog(@"%f",fabs(view.frame.origin.x - self.scrollView.contentOffset.x));
        if (fabs(view.frame.origin.x - self.scrollView.contentOffset.x) < _pageSize.width){
            view.frame = CGRectMake(view.frame.origin.x, 0, _pageSize.width, _pageSize.height);
        }else{
            view.frame = CGRectMake(view.frame.origin.x, 0, _pageSize.width * 0.6, _pageSize.height * 0.6);
        }
    }
}

- (NSMutableArray *)visiableCells{
    if (!_visiableCells){
        _visiableCells = [NSMutableArray arrayWithCapacity:0];
    }
    return _visiableCells;
}

- (NSMutableArray *)cells{
    if (!_cells){
        _cells = [NSMutableArray arrayWithCapacity:0];
    }
    return _cells;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
