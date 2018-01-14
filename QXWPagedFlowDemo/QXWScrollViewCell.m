//
//  QXWScrollViewCell.m
//  QXWPagedFlowDemo
//
//  Created by 王庆学 on 2018/1/14.
//  Copyright © 2018年 王庆学. All rights reserved.
//

#import "QXWScrollViewCell.h"

@interface QXWScrollViewCell ()

@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

@end

@implementation QXWScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self loadXibView];
    }
    return self;
}

- (void)loadXibView{
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.baseView.frame = self.bounds;
    [self addSubview:self.baseView];
}

- (void)setWithImageName:(NSString *)imageName{
    self.backGroundImageView.image = [UIImage imageNamed:imageName];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
