//
//  HKYTypeRectCollectionCell.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/6.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYTypeRectCollectionCell.h"
#import "UIButton+HKYImageTitleSpacing.h"
#import "HKYShapeMode.h"


@interface HKYTypeRectCollectionCell ()
@property (nonatomic, strong) NSMutableArray *btnMutArr;
@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, assign) RectTypeOptions defaultRectType;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation HKYTypeRectCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultRectType = RectTypeOptionEllipse;
    }
    return self;
}


-(void)setDataSource:(NSArray *)dataSource defaultRectType:(RectTypeOptions)defaultRectType{
    self.defaultRectType = defaultRectType;
    self.dataSource = dataSource;
    [self p_addRectOptions];
}
-(void)setDefaultRectType:(RectTypeOptions)defaultRectType{
    _defaultRectType = defaultRectType;
    for (UIButton *tempBtn in self.btnMutArr) {
        if (tempBtn.tag == defaultRectType) {
            tempBtn.enabled = NO;
            self.lastBtn = tempBtn;
        }else{
            tempBtn.enabled = YES;
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.btnMutArr.count>0) {
        UIEdgeInsets btnInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat btnWidth = (SCREEN_WIDTH-btnInset.left-btnInset.right)/self.btnMutArr.count;
        for (int i = 0; i<self.btnMutArr.count; i++) {
            UIButton *tempBtn = (UIButton *)self.btnMutArr[i];
            [tempBtn setFrame:CGRectMake(btnInset.left + i*btnWidth, btnInset.top, btnWidth, CGRectGetHeight(self.frame)-btnInset.top-btnInset.bottom)];
            [tempBtn layoutButtonWithEdgeInsetsStyle:BNCButtonEdgeInsetsStyleTop imageTitleSpace:10.f];
        }
    }
}

-(void)p_addRectOptions{
    for (int i = 0; i< self.dataSource.count; i++) {
        HKYShapeMode *tempModel = self.dataSource[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:tempModel.title forState:UIControlStateNormal];
        [button.titleLabel setFont:tempModel.titleFont];
        [button setTitleColor:tempModel.normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:tempModel.selectedTitleColor forState:UIControlStateDisabled];
        button.tag = tempModel.tag;
        
        if (tempModel.normalImg) {
            [button setImage:tempModel.normalImg forState:UIControlStateNormal];
        }
        if (tempModel.selectedImg) {
            [button setImage:tempModel.selectedImg forState:UIControlStateDisabled];
        }
        
        [button addTarget:self action:@selector(p_clickColorOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.btnMutArr addObject:button];
        
        if (i == self.defaultRectType) {
            button.enabled = NO;
            self.lastBtn = button;
        }
    }
}


-(void)p_clickColorOption:(UIButton *)sender{
    self.lastBtn.enabled = YES;
    sender.enabled = NO;
    self.lastBtn = sender;
    
    if (self.rectTypeDelegate && [self.rectTypeDelegate respondsToSelector:@selector(changeRectTypeOption:)]) {
        [self.rectTypeDelegate changeRectTypeOption:sender.tag];
    }
}
    
#pragma mark - Lazy Methods

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = [NSMutableArray array];
    }
    return _btnMutArr;
}

@end
