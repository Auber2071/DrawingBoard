//
//  DrawBoard.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/25.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "DrawBoard.h"
#import "DrawBoardView.h"
#import "EditView.h"

@interface DrawBoard ()<DrawBoardViewDeletage>

@property (nonatomic, strong) DrawBoardView *drawBoardView;
@property (nonatomic, strong) EditView *editView;

@end

@implementation DrawBoard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.drawBoardView];
        [self addSubview:self.editView];
        [self p_addSubViews];
    }
    return self;
}


-(void)p_addSubViews{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor grayColor]];
    [cancelBtn.layer setCornerRadius:5.f];
    [cancelBtn addTarget:self action:@selector(p_cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setFrame:CGRectMake(10, 20, 60, 30)];
    [self addSubview:cancelBtn];
 
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn setBackgroundColor:[UIColor greenColor]];
    [finishBtn.layer setCornerRadius:5.f];
    [finishBtn addTarget:self action:@selector(p_finishEdit) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setFrame:CGRectMake(SCREEN_WIDTH - 70, 20, 60, 30)];
    [self addSubview:finishBtn];
}

-(void)p_cancelEdit{
    if (self.drawBoardDelegate && [self.drawBoardDelegate respondsToSelector:@selector(cancelEdit)]) {
        [self.drawBoardDelegate cancelEdit];
    }
}
-(void)p_finishEdit{
    if (self.drawBoardDelegate && [self.drawBoardDelegate respondsToSelector:@selector(finishEditWithImage:)]) {
        [self.drawBoardDelegate finishEditWithImage:[UIImage imageNamed:@"background"]];
    }
}


#pragma mark - DrawBoardViewDeletage

-(void)drawBoard:(DrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus{
    NSLog(@"drawingStatus:%ld",(long)drawingStatus);
    
    __weak typeof(self) tempSelf = self;
    NSTimeInterval timerInterval = 0.2f;
    switch (drawingStatus) {
        case DrawingStatusBegin:{
            [UIView animateWithDuration:timerInterval animations:^{
                CGFloat Y =  CGRectGetHeight(tempSelf.frame);
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.frame), CGRectGetHeight(tempSelf.frame) - Y)];
            }];
        }
            break;
        case DrawingStatusEnd:{
            CGFloat Y = CGRectGetHeight(tempSelf.frame)/10*9;
            [UIView animateWithDuration:timerInterval animations:^{
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.frame), CGRectGetHeight(tempSelf.frame) - Y)];
            }];
        }
            break;
        default:
            break;
    }
}


-(DrawBoardView *)drawBoardView{
    if (!_drawBoardView) {
        _drawBoardView = [[DrawBoardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _drawBoardView.delegate = self;
    }
    return _drawBoardView;
}

-(EditView *)editView{
    if (!_editView) {
        CGFloat Y = CGRectGetHeight(self.frame)/10*9;
        _editView = [[EditView alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - Y)];
    }
    return _editView;
}

@end
