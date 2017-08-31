//
//  EditView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "EditView.h"


NSString * const EditMenuTypeChangeNotification = @"EditMenuTypeChangeNotification";


@interface EditView ()
@property (nonatomic, strong) UIScrollView *actionScrollView;

@property (nonatomic, strong) NSMutableArray *colorMutArr;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) EditMenuType selectEditMenuTye;

@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation EditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        _lineColor = [UIColor redColor];
        _selectEditMenuTye = EditMenuTypeLine;
        
        
        
        [self p_addActionBtns];
        [self p_addCollectionView];
        
    }
    return self;
}

-(void)p_addCollectionView{
    CollectionView *collectionView = [[CollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.actionScrollView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(self.actionScrollView.frame))];
    [self addSubview:collectionView];
}



-(void)p_addActionBtns{
    UIEdgeInsets btnInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    CGFloat padding = 0.f;
    CGFloat showBtnCount = 8.f;
    NSUInteger btnCount = 8;
    CGFloat btnW = (CGRectGetWidth(self.frame) - btnInsets.left - btnInsets.right - padding*(showBtnCount-1))/showBtnCount;

    
    
    CGFloat actionScrolVH = 30;
    UIScrollView *actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), actionScrolVH)];
    self.actionScrollView = actionScrollView;
    
    actionScrollView.backgroundColor = [UIColor grayColor];
    actionScrollView.alpha = 0.8f;
    actionScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat scrolContentSizeW = btnW*btnCount+btnInsets.left+btnInsets.right+(btnCount-1)*padding;
    [actionScrollView setContentSize:CGSizeMake(scrolContentSizeW, actionScrolVH)];
    [self addSubview:actionScrollView];

    
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(btnInsets.left + i*(btnW + padding), btnInsets.top, btnW, CGRectGetHeight(actionScrollView.frame))];
        [button addTarget:self action:@selector(p_changeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:{
                [button setTitle:@"画线" forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor redColor];
                self.lastButton = button;
                button.tag = EditMenuTypeLine;
            }
                break;
            case 1:{
                [button setTitle:@"文字" forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.tag = EditMenuTypeCharacter;
            }
                break;
            case 2:{
                [button setTitle:@"方形" forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.tag = EditMenuTypeRectangle;
            }
                break;
            case 3:{
                [button setTitle:@"圆形" forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.tag = EditMenuTypeCyclo;
            }
                break;
            case 4:{
                [button setImage:[UIImage imageNamed:@"eraser"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeEraser;
            }
                break;
            case 5:{
                [button setImage:[UIImage imageNamed:@"chexiao"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeBack;
            }
                break;
            case 6:{
                [button setImage:[UIImage imageNamed:@"qianjin"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeGoForward;
            }
                break;
            case 7:{
                [button setImage:[UIImage imageNamed:@"qingkong"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeClearAll;
            }
                break;
        }
        [actionScrollView addSubview:button];
    }
}



-(void)p_changeAction:(UIButton *)sender{
    if (![self.lastButton isEqual:sender]) {
        sender.backgroundColor = [UIColor redColor];
        self.lastButton.backgroundColor = [UIColor grayColor];
        self.lastButton = sender;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EditMenuTypeChangeNotification object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:sender.tag] forKey:@"selectedEditMenuType"]];
}

@end
