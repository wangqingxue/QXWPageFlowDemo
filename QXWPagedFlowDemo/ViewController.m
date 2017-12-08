//
//  ViewController.m
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2017/12/9.
//  Copyright © 2017年 王庆学. All rights reserved.
//

#import "ViewController.h"
#import "PageFlowView.h"

@interface ViewController ()<PageFlowViewDataSourceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (NSInteger)pageFlowScrollViewPageCount{
    return 20;
}

- (UIView *)pageFlowViewWithIndex:(NSInteger)index{
    return nil;
}

- (CGSize)pageFlowPageSizeFromScrollView{
    return CGSizeZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
