//
//  PageFlowView.h
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2017/12/9.
//  Copyright © 2017年 王庆学. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageFlowViewDataSourceDelegate <NSObject>

- (UIView *)pageFlowViewWithIndex:(NSInteger)index;

- (NSInteger)pageFlowScrollViewPageCount;

- (CGSize)pageFlowPageSizeFromScrollView;

@end

@interface PageFlowView : UIView

@property (nonatomic, assign) id<PageFlowViewDataSourceDelegate> dateSource;

- (void)reloadData;

@end
