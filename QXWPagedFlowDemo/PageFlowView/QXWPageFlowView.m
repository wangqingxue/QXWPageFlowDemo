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

@property (nonatomic, strong) NSMutableArray *visiableCells;

@property (nonatomic, assign) NSInteger startPoint;

@property (nonatomic, assign) NSInteger endPoint;

@property (nonatomic, strong) NSMutableArray *allCells;

@end

@implementation QXWPageFlowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self InitializeWithFrame:(CGRect)frame];
    }
    return self;
}

#pragma mark --初始化
- (void)InitializeWithFrame:(CGRect)frame{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.scrollView];
}

#pragma mark 刷新数据
- (void)reloadData{
    if ([_dateSource respondsToSelector:@selector(pageFlowScrollViewPageCount)]){
        _originCount = [_dateSource pageFlowScrollViewPageCount];
        _pageCount = _originCount * 3;
    }
    if ([_dateSource respondsToSelector:@selector(pageFlowPageSizeFromScrollView)]){
        _pageSize = [_dateSource pageFlowPageSizeFromScrollView];
    }
    self.scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, 0);
    for (NSInteger i = 0; i < _pageCount; i++){
        UIView *view = [_dateSource pageFlowViewWithIndex:(i % 4)];
        view.frame = CGRectMake(i * _pageSize.width, 0, _pageSize.width, _pageSize.height);
        [self.allCells addObject:view];
        [self.scrollView addSubview:view];
    }
    [self.scrollView setContentOffset:CGPointMake(_pageSize.width * _originCount, 0) animated:NO];
    [self calculaterStartPointAndEndPointWith:CGPointMake(_pageSize.width * _originCount, 0)];
}

#pragma mark 计算开始显示的index和结束显示的index
- (void)calculaterStartPointAndEndPointWith:(CGPoint)contentOffsetPoint{
    CGFloat startX = contentOffsetPoint.x - [UIScreen mainScreen].bounds.size.width;
    CGFloat endX = contentOffsetPoint.x + self.frame.size.width;
    NSInteger startIndex = 0,endIndex = 0;
    for (NSInteger i = 0; i < _pageCount; i++){
        if ((i + 1) * _pageSize.width > startX){
            startIndex = i;
            break;
        }
    }
    for (NSInteger i = startIndex; i < _pageCount; i++){
        if (((i + 1) * _pageSize.width > endX)){
            endIndex = i;
            break;
        }
        if (i * _pageSize.width >= endIndex){
            endIndex = _pageCount - 1;
        }
    }
    NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
    [self setCellFrameWithCGRect:range];
}

#pragma mark 将view添加到ScrollView上去
- (void)setCellFrameWithCGRect:(NSRange)rect{
    [self.visiableCells removeAllObjects];
    for (int i = (int)rect.location; i <= rect.location + rect.length; i++){
        UIView *view = self.allCells[i];
        [self.visiableCells addObject:view];
    }
    [self setVisibableView];
    [self setLoacation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self calculaterStartPointAndEndPointWith:scrollView.contentOffset];
    
}

#pragma mark 调整显示View的大小
- (void)setVisibableView{
    for (UIView *view in self.visiableCells){
        CGFloat floatW = fabs(view.frame.origin.x - self.scrollView.contentOffset.x);
        CGFloat widthP = _pageSize.width;
        CGFloat ratido = floatW / widthP;
        if (floatW < widthP / 2){
            CGPoint pointCenter = view.center;
            view.frame = CGRectMake(0, 0, _pageSize.width - 30 * ratido, _pageSize.height - 30 * ratido);
            view.center = pointCenter;
        }else if (floatW < widthP){
            CGPoint pointCenter = view.center;
            view.frame = CGRectMake(0, 0, _pageSize.width - 30 * ratido, _pageSize.height - 30 * ratido);
            view.center = pointCenter;
        }else{
            CGPoint pointCenter = view.center;
            view.frame = CGRectMake(0, 0, _pageSize.width - 30, _pageSize.height - 30);
            view.center = pointCenter;
        }
    }
}

- (void)setLoacation{
    if (self.scrollView.contentOffset.x <= self.scrollView.frame.size.width * 1){
        self.scrollView.contentOffset = CGPointMake((1 + _originCount) * self.scrollView.frame.size.width, 0);
        _startPoint = 0;
        _endPoint = 0;
    }
        if(self.scrollView.contentOffset.x >= self.scrollView.frame.size.width * (_pageCount - 2)){
            self.scrollView.contentOffset = CGPointMake((_pageCount - _originCount - 2) * self.scrollView.frame.size.width, 0);
            _startPoint = 0;
            _endPoint = 0;
    }
}

- (NSMutableArray *)visiableCells{
    if (!_visiableCells){
        _visiableCells = [NSMutableArray arrayWithCapacity:0];
    }
    return _visiableCells;
}

- (NSMutableArray *)allCells{
    if (!_allCells){
        _allCells = [NSMutableArray arrayWithCapacity:0];
    }
    return _allCells;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
