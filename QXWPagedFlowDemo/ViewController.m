//
//  ViewController.m
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2017/12/9.
//  Copyright © 2017年 王庆学. All rights reserved.
//

#import "ViewController.h"
#import "QXWPageFlowView.h"

@interface ViewController ()<PageFlowViewDataSourceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QXWPageFlowView *qxwPageFlowView = [[QXWPageFlowView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    qxwPageFlowView.dateSource = self;
    [self.view addSubview:qxwPageFlowView];
    [qxwPageFlowView reloadData];
}

- (NSInteger)pageFlowScrollViewPageCount{
    return 20;
}

- (UIView *)pageFlowViewWithIndex:(NSInteger)index{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGSize)pageFlowPageSizeFromScrollView{
    return CGSizeMake(80, 80);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
