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
        //[self p_addCollectionView];
        
    }
    return self;
}

-(void)p_addCollectionView{
    CollectionView *collectionView = [[CollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.actionScrollView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(self.actionScrollView.frame))];
    [self addSubview:collectionView];
}



-(void)p_addActionBtns{
    CGFloat actionScrolVH = CGRectGetHeight(self.frame);
    UIScrollView *actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), actionScrolVH)];
    self.actionScrollView = actionScrollView;
    actionScrollView.backgroundColor = [UIColor grayColor];
    actionScrollView.alpha = 0.8f;
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
        [button setBackgroundColor:[UIColor grayColor]];
        [button setFrame:CGRectMake(btnInsets.left + i*(btnW + padding), (CGRectGetHeight(actionScrollView.frame) - btnW)/2.f, btnW, btnW)];
        [button.layer setCornerRadius: btnW/2.f];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.f;
        
        [button addTarget:self action:@selector(p_changeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:{
                [button setImage:[UIImage imageNamed:@"文字"] forState:UIControlStateNormal];
                
                button.tag = EditMenuTypeLine;
            }
                break;
            case 1:{
                [button setImage:[UIImage imageNamed:@"画笔"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeCharacter;
            }
                break;
            case 2:{
                [button setImage:[UIImage imageNamed:@"图形"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeRect;
            }
                break;
            case 3:{
                [button setImage:[UIImage imageNamed:@"eraser"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeEraser;
            }
                break;
            case 4:{
                [button setImage:[UIImage imageNamed:@"chexiao"] forState:UIControlStateNormal];
                button.tag = EditMenuTypeBack;
            }
                break;
        }
        [actionScrollView addSubview:button];
    }
}





-(void)p_changeAction:(UIButton *)sender{

    sender.backgroundColor = [UIColor redColor];
    self.lastButton.backgroundColor = [UIColor grayColor];
    self.lastButton = sender;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EditMenuTypeChangeNotification object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:sender.tag] forKey:@"selectedEditMenuType"]];
}

@end
