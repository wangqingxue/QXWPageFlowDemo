//
//  ViewController.m
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2017/12/9.
//  Copyright © 2017年 王庆学. All rights reserved.
//

#import "ViewController.h"
#import "QXWPageFlowView.h"
#import "QXWScrollViewCell.h"

@interface ViewController ()<PageFlowViewDataSourceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QXWPageFlowView *qxwPageFlowView = [[QXWPageFlowView alloc]initWithFrame:CGRectMake(100, 100, 240, 240)];
    qxwPageFlowView.dateSource = self;
    [self.view addSubview:qxwPageFlowView];
    [qxwPageFlowView reloadData];
}

- (NSInteger)pageFlowScrollViewPageCount{
    return 4;
}

- (UIView *)pageFlowViewWithIndex:(NSInteger)index{
    QXWScrollViewCell *scrollViewCell = [[QXWScrollViewCell alloc]initWithFrame:CGRectMake(0, 0, 240, 240)];
    [scrollViewCell setWithImageName:[NSString stringWithFormat:@"%ld",index] WithIndex:index];
    return scrollViewCell;
}

- (CGSize)pageFlowPageSizeFromScrollView{
    return CGSizeMake(240, 240);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
