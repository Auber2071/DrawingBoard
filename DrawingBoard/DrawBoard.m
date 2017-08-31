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

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) DrawBoardView *drawBoardView;
@property (nonatomic, strong) EditView *editView;

@end

@implementation DrawBoard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.drawBoardView];
        [self addSubview:self.editView];
    }
    return self;
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
            CGFloat Y = CGRectGetHeight(tempSelf.frame)/5*4;
            [UIView animateWithDuration:timerInterval animations:^{
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.frame), CGRectGetHeight(tempSelf.frame) - Y)];
            }];
        }
            break;
        default:
            break;
    }
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView =  [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setImage:[UIImage imageNamed:@"Vencent.jpg"]];
    }
    return _backImageView;
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
        CGFloat Y =  CGRectGetHeight(self.frame)/5*4;
        _editView = [[EditView alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - Y)];
    }
    return _editView;
}

@end
