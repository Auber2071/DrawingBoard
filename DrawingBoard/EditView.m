//
//  EditView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "EditView.h"

@interface EditView ()
@property (nonatomic, strong) UIScrollView *actionScrollView;
@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation EditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        [self p_addActionBtns];
    }
    return self;
}



-(void)p_addActionBtns{
    CGFloat actionScrolVH = CGRectGetHeight(self.frame);
    UIScrollView *actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), actionScrolVH)];
    self.actionScrollView = actionScrollView;
    actionScrollView.backgroundColor = UIColorFromRGB(0xDCDCDC);
    actionScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:actionScrollView];
    
    
    
    CGFloat padding = 0.f;
    UIEdgeInsets btnInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    NSUInteger btnCount = 5;
    CGFloat showBtnCount = btnCount;
    
    CGFloat btnW = (CGRectGetWidth(self.frame) - btnInsets.left - btnInsets.right - padding*(showBtnCount-1))/showBtnCount;
    btnW = btnW>(CGRectGetHeight(actionScrollView.frame) - btnInsets.top - btnInsets.bottom)? (CGRectGetHeight(actionScrollView.frame) - btnInsets.top - btnInsets.bottom) : btnW;
    padding = (CGRectGetWidth(self.frame) - btnW*showBtnCount - btnInsets.left - btnInsets.right)/(showBtnCount-1);
    
    
    CGFloat scrolContentSizeW = btnW*btnCount+btnInsets.left+btnInsets.right+(btnCount-1)*padding;
    [actionScrollView setContentSize:CGSizeMake(scrolContentSizeW, actionScrolVH)];

    
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:UIColorFromRGB(0xC0C0C0)];
        [button setFrame:CGRectMake(btnInsets.left + i*(btnW + padding), (CGRectGetHeight(actionScrollView.frame) - btnW)/2.f, btnW, btnW)];
        [button.layer setCornerRadius: btnW/2.f];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.f;
        
        [button addTarget:self action:@selector(p_selectEditType:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:{
                [button setImage:[UIImage imageNamed:@"文字"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeOptionCharacter;
            }
                break;
            case 1:{
                [button setImage:[UIImage imageNamed:@"画笔"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"画笔_selected"] forState:UIControlStateSelected];
                button.tag = EditMenuTypeOptionLine;
            }
                break;
            case 2:{
                [button setImage:[UIImage imageNamed:@"图形"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"图形_selected"] forState:UIControlStateSelected];
                button.tag = EditMenuTypeOptionRect;
            }
                break;
            case 3:{
                [button setImage:[UIImage imageNamed:@"橡皮"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"橡皮_selected"] forState:UIControlStateSelected];
                button.tag = EditMenuTypeOptionEraser;
            }
                break;
            case 4:{
                [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"返回_selected"] forState:UIControlStateHighlighted];
                button.tag = EditMenuTypeOptionBack;
            }
                break;
        }
        [actionScrollView addSubview:button];
    }
}

-(void)p_selectEditType:(UIButton *)sender{
    if (!sender.isSelected) {
        self.lastButton.selected = !self.lastButton.selected;
        sender.selected = !sender.selected;
        self.lastButton = sender;
    }
    
    if (self.editViewDelegate && [self.editViewDelegate respondsToSelector:@selector(EditView:changedDrawingOption:)]) {
        [self.editViewDelegate EditView:self changedDrawingOption:sender.tag];
    }
}

@end
