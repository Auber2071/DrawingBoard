//
//  TypeRectCollectionCell.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/6.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TypeRectCollectionCell.h"

@interface TypeRectCollectionCell ()
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *btnMutArr;

@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation TypeRectCollectionCell

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
            tempBtn.selected = YES;
            self.lastBtn = tempBtn;
        }else{
            tempBtn.selected = NO;
        }
    }
}

-(void)layoutSubviews{
    UIEdgeInsets btnInset = UIEdgeInsetsMake(0, SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5);
    CGFloat btnWidth = (SCREEN_WIDTH-btnInset.left-btnInset.right)/3.f;
    for (int i = 0; i<self.btnMutArr.count; i++) {
        UIButton *tempBtn = self.btnMutArr[i];
        [tempBtn setFrame:CGRectMake(btnInset.left + i*btnWidth, 0, btnWidth, CGRectGetHeight(self.frame))];
    }
}

-(void)p_addRectOptions{
    for (int i = 0; i< self.titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
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
        if (button.tag == _defaultRectType) {
            button.selected = YES;
            self.lastBtn = button;
        }
    }
}


-(void)p_clickColorOption:(UIButton *)sender{
    if (!sender.isSelected) {
        self.lastBtn.selected = !self.lastBtn.selected;
        sender.selected = !sender.selected;
        self.lastBtn = sender;
    }
    
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
