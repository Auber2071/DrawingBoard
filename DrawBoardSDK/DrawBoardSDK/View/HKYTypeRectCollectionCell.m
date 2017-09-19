//
//  HKYTypeRectCollectionCell.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/6.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYTypeRectCollectionCell.h"

@interface HKYTypeRectCollectionCell ()
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *btnMutArr;

@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation HKYTypeRectCollectionCell
static NSTimeInterval duration = 0.1f;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultRectType = RectTypeOptionEllipse;
        [self p_addRectOptions];
    }
    return self;
}

-(void)setDefaultRectType:(RectTypeOptions)defaultRectType{
    _defaultRectType = defaultRectType;
    for (UIButton *tempBtn in self.btnMutArr) {
        if (tempBtn.tag == defaultRectType) {
            tempBtn.enabled = NO;
            self.lastBtn = tempBtn;
            [UIView animateWithDuration:duration animations:^{
                self.indicatorView.width = tempBtn.titleLabel.width;
                self.indicatorView.centerX = tempBtn.centerX;
            }];
        }else{
            tempBtn.enabled = YES;
        }
    }
}


-(void)p_addRectOptions{
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = UIColorFromRGB(0xffa500);
    self.indicatorView.height = 2;
    self.indicatorView.y = CGRectGetHeight(self.frame) - self.indicatorView.height;
    [self.contentView addSubview:self.indicatorView];
    
    UIEdgeInsets btnInset = UIEdgeInsetsMake(0, SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5);
    CGFloat btnWidth = (SCREEN_WIDTH-btnInset.left-btnInset.right)/3.f;
    for (int i = 0; i< self.titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xffa500) forState:UIControlStateDisabled];
        [button setFrame:CGRectMake(btnInset.left + i*btnWidth, 0, btnWidth, CGRectGetHeight(self.frame)-2)];
        [button layoutIfNeeded];
        [button addTarget:self action:@selector(p_clickColorOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.btnMutArr addObject:button];
        
        switch (i) {
            case 0:{
                button.tag = RectTypeOptionSquare;
            }
                break;
            case 1:{
                button.tag = RectTypeOptionEllipse;
            }
                break;
            case 2:{
                button.tag = RectTypeOptionArrows;
            }
                break;
        }
        if (i == self.defaultRectType) {
            button.enabled = NO;
            self.lastBtn = button;
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
        
    }
}


-(void)p_clickColorOption:(UIButton *)sender{
    self.lastBtn.enabled = YES;
    sender.enabled = NO;
    self.lastBtn = sender;
    
    [UIView animateWithDuration:duration animations:^{
        self.indicatorView.width = sender.titleLabel.width;
        self.indicatorView.centerX = sender.centerX;
    }];
    
    if (self.rectTypeDelegate && [self.rectTypeDelegate respondsToSelector:@selector(changeRectTypeOption:)]) {
        [self.rectTypeDelegate changeRectTypeOption:sender.tag];
    }
}
    
#pragma mark - Lazy Methods
-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"矩形",@"椭圆",@"箭头"];
    }
    return _titleArr;
}
-(NSMutableArray *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = [NSMutableArray array];
    }
    return _btnMutArr;
}
@end
