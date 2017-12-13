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

@property (nonatomic, assign) NSRange lastRange;

@property (nonatomic, assign) BOOL first;

@end

@implementation QXWPageFlowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self Initialize];
    }
    return self;
}

- (void)Initialize{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor greenColor];
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
    NSInteger startIndex = 0,endIndex = 0;
    for (NSInteger i = 0; i < _pageCount; i++){
        if ((i + 1) * _pageSize.width > startX){
            startIndex = i;
            break;
        }
    }
    for (NSInteger i = startIndex; i < _pageCount; i++){
        if (((i + 1) * _pageSize.width > endX) && (i * _pageSize.width < endX)){
            endIndex = i;
            break;
        } 
    }
    NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
    [self setCellFrameWithCGRect:range];
}


- (void)setCellFrameWithCGRect:(NSRange)rect{
//    [self.visiableCells removeAllObjects];
    for (int i = (int)rect.location; i < rect.location + rect.length; i++){
        if (i < _lastRange.location){
            UIView *lastView = self.visiableCells.lastObject;
            [lastView removeFromSuperview];
            if (_lastRange.length){
            [self.visiableCells removeLastObject];
            }
            UIView *view = [_dateSource pageFlowViewWithIndex:i];
            view.frame = CGRectMake(i * _pageSize.width,0,_pageSize.width,_pageSize.height);
            [self.scrollView addSubview:view];
            [self.visiableCells insertObject:view atIndex:0];
            _lastRange = NSMakeRange(_lastRange.location - 1, _lastRange.length);
            NSLog(@"%ld",i);
        }else if (i > _lastRange.location + _lastRange.length){
            UIView *lastView = [self.visiableCells firstObject];
            [lastView removeFromSuperview];
            if (_lastRange.length){
                [self.visiableCells removeObjectAtIndex:0];
            }
            UIView *view = [_dateSource pageFlowViewWithIndex:i];
            view.frame = CGRectMake(i * _pageSize.width,0,_pageSize.width,_pageSize.height);
            [self.scrollView addSubview:view];
            [self.visiableCells addObject:view];
            _lastRange = NSMakeRange(_lastRange.location+ 1, _lastRange.length);
            NSLog(@"%ld",i);
            
        }
        
        
    };
    _first = YES;
    [self setVisibableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self calculaterStartPointAndEndPointWith:scrollView.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.x < _pageSize.width || scrollView.contentOffset.x > (_pageCount - 1) * _pageSize.width){
//        scrollView.contentOffset = CGPointMake(_pageCount * _pageSize.width, 0);
//    }
}

- (void)setVisibableView{
    for (UIView *view in self.visiableCells){
        CGFloat floatW = fabs(view.frame.origin.x - self.scrollView.contentOffset.x);
        CGFloat widthP = _pageSize.width;
        if (floatW < widthP / 2){
//            NSLog(@"juli = %lf",floatW);
//            NSLog(@"width = %lf",widthP);
            CGPoint pointCenter = view.center;
            view.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
            view.center = pointCenter;
        }else{
            CGPoint pointCenter = view.center;
            view.frame = CGRectMake(0, 0, _pageSize.width - 30, _pageSize.height - 30);
            view.center = pointCenter;
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
