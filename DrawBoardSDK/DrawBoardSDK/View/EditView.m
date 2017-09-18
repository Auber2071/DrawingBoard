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
    actionScrollView.backgroundColor = UIColorFromRGBP(0xEEEEEE,0.9);
    actionScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:actionScrollView];
    
    
    NSUInteger btnCount = 5;
    NSUInteger showCount = btnCount;
    UIEdgeInsets btnInsets = UIEdgeInsetsMake(5, 35, 5, 35);
    CGFloat btnH = CGRectGetHeight(self.frame) - btnInsets.top - btnInsets.bottom;
    CGFloat btnW = MIN(43.f, btnH);
    CGFloat padding = (CGRectGetWidth(self.frame) - btnInsets.left - btnInsets.right - showCount*btnW)/(showCount-1);
    
    CGFloat scrolContentSizeW = btnW*btnCount+btnInsets.left+btnInsets.right+(btnCount-1)*padding;
    [actionScrollView setContentSize:CGSizeMake(scrolContentSizeW, actionScrolVH)];

    
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(btnInsets.left + i*(btnW + padding), (CGRectGetHeight(actionScrollView.frame) - btnW)/2.f, btnW, btnW)];
        [button.layer setCornerRadius: btnW/2.f];
        [button addTarget:self action:@selector(p_selectEditType:) forControlEvents:UIControlEventTouchUpInside];
        
        NSBundle *bundle = DrawBoardBundle;
        switch (i) {
            case 0:{
                UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"wenzi@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                [button setImage:image forState:UIControlStateNormal];
                button.tag = EditMenuTypeOptionCharacter;
            }
                break;
            case 1:{
                UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"huabi@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                UIImage *selectedImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"huabi_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];

                [button setImage:image forState:UIControlStateNormal];
                [button setImage:selectedImg forState:UIControlStateSelected];
                button.tag = EditMenuTypeOptionLine;
            }
                break;
            case 2:{
                UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"tuxing@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                UIImage *selectedImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"tuxing_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];

                [button setImage:image forState:UIControlStateNormal];
                [button setImage:selectedImg forState:UIControlStateSelected];
                button.tag = EditMenuTypeOptionRect;
            }
                break;
            case 3:{
                UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"shanchu@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                UIImage *selectedImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"shanchu_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];

                [button setImage:image forState:UIControlStateNormal];
                [button setImage:selectedImg forState:UIControlStateSelected];
                button.tag = EditMenuTypeOptionEraser;
            }
                break;
            case 4:{
                UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"huitui@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                UIImage *hightLightImg = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"huitui_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                [button setImage:image forState:UIControlStateNormal];
                [button setImage:hightLightImg forState:UIControlStateHighlighted];
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
