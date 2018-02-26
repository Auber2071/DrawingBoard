//
//  HKYEditView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYEditView.h"
#import "UIButton+HKYImageTitleSpacing.h"

@interface HKYEditView ()
@property (nonatomic, strong) UIScrollView *actionScrollView;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) NSMutableArray <UIButton*>*buttonMutArr;

@property (nonatomic, strong) UIView *line;

@end

@implementation HKYEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        [self p_setupSubViews];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.line setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
    CGFloat actionScrolVH = CGRectGetHeight(self.frame) - CGRectGetHeight(self.line.frame);
    [self.actionScrollView setFrame:CGRectMake(0, 1, CGRectGetWidth(self.frame), actionScrolVH)];
    
    if (self.buttonMutArr.count>0) {
        NSInteger buttonCount = self.buttonMutArr.count;
        UIEdgeInsets btnInsets = UIEdgeInsetsMake(5, 30, 5, 30);
        CGFloat btnH = CGRectGetHeight(self.actionScrollView.frame) - btnInsets.top - btnInsets.bottom;
        CGFloat btnW = MIN(CGRectGetHeight(self.actionScrollView.frame), btnH);
        btnH = btnW;
        CGFloat padding = (CGRectGetWidth(self.actionScrollView.frame) - btnInsets.left - btnInsets.right - buttonCount*btnW)/(buttonCount-1);
        for (int i = 0; i<self.buttonMutArr.count; i++) {
            UIButton *tempBtn = self.buttonMutArr[i];
            [tempBtn setFrame:CGRectMake(btnInsets.left + i*(btnW + padding), (CGRectGetHeight(self.actionScrollView.frame) - btnH)/2.f, btnW, btnH)];
            [tempBtn layoutButtonWithEdgeInsetsStyle:BNCButtonEdgeInsetsStyleTop imageTitleSpace:7.f];

        }
        CGFloat scrolContentSizeW = btnW*buttonCount+btnInsets.left+btnInsets.right+(buttonCount-1)*padding;
        [self.actionScrollView setContentSize:CGSizeMake(scrolContentSizeW, CGRectGetHeight(self.actionScrollView.frame))];
    }
}

-(void)p_setupSubViews{
    [self addSubview:self.line];
    [self addSubview:self.actionScrollView];
}

-(void)setDataSource:(NSArray<HKYEditViewModel *> *)dataSource{
    _dataSource = dataSource;
    [self p_setupActionBtns];
}

-(void)p_setupActionBtns{
    [self.buttonMutArr removeAllObjects];
    
    for (int i = 0; i<self.dataSource.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(p_selectEditType:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
        HKYEditViewModel *model = self.dataSource[i];

        button.tag = model.itemTag;
        if (model.itemNormalImgName.length>0) {
            UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:model.itemNormalImgName ofType:@"png" inDirectory:@"Images/otherImage"]];
            [button setImage:image forState:UIControlStateNormal];
        }
        if (model.itemSelectedImgName.length>0) {
            UIImage *selectedImg = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:model.itemSelectedImgName ofType:@"png" inDirectory:@"Images/otherImage"]];
            [button setImage:selectedImg forState:UIControlStateSelected];
            
            if (model.itemTitle.length>0) {
                [button setTitle:model.itemTitle forState:UIControlStateSelected];
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
            }
        }
        if (model.itemHighLightImgName.length>0) {
            UIImage *hightLightImg = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:model.itemHighLightImgName ofType:@"png" inDirectory:@"Images/otherImage"]];
            [button setImage:hightLightImg forState:UIControlStateHighlighted];
            
            if (model.itemTitle.length>0) {
                [button setTitle:model.itemTitle forState:UIControlStateHighlighted];
                [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];

            }
        }
        if (model.itemTitle.length>0) {
            [button setTitle:model.itemTitle forState:UIControlStateNormal];
            [button setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        }
        
        [self.actionScrollView addSubview:button];
        [self.buttonMutArr addObject:button];
    }
         
}

    
-(void)p_selectEditType:(UIButton *)sender{
    if (sender.tag != EditMenuTypeOptionBack && self.lastButton == sender) {
        return;
    }
    if (!sender.isSelected) {
        self.lastButton.selected = !self.lastButton.selected;
        sender.selected = !sender.selected;
        self.lastButton = sender;
    }
    
    if (self.editViewDelegate && [self.editViewDelegate respondsToSelector:@selector(HKYEditView:changedDrawingOption:)]) {
        [self.editViewDelegate HKYEditView:self changedDrawingOption:sender.tag];
    }
}

#pragma mark - Get Methods

-(UIScrollView *)actionScrollView{
    if (!_actionScrollView) {
        _actionScrollView = [[UIScrollView alloc] init];
        _actionScrollView.backgroundColor = UIColorFromRGB(0xffffff);
        _actionScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _actionScrollView;
}
-(NSMutableArray<UIButton *> *)buttonMutArr{
    if (!_buttonMutArr) {
        _buttonMutArr = [NSMutableArray array];
    }
    return _buttonMutArr;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _line;
}
@end
