//
//  DrawBoardViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/4.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "DrawBoardViewController.h"
#import "DrawBoardView.h"
#import "EditView.h"
#import "InputCharacterViewController.h"

@interface DrawBoardViewController ()<DrawBoardViewDeletage,EditViewDelegate,InputCharacterViewControllerDelegate>

@property (nonatomic, strong) DrawBoardView *drawBoardView;
@property (nonatomic, strong) EditView *editView;
@property (nonatomic, strong) UIImageView *drawBoardBackImgV;
@property (nonatomic, strong) UIImage *drawBoardBackImg;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *finishBtn;

@end

@implementation DrawBoardViewController

-(instancetype)initWithImage:(UIImage *)backImage{
    self = [super init];
    if (self) {
        _drawBoardBackImg = backImage;
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.drawBoardBackImgV];
    [self.view addSubview:self.drawBoardView];
    [self.view addSubview:self.editView];

    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.finishBtn];

    
}






#pragma mark - DrawBoardViewDeletage

-(void)drawBoard:(DrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus{
    NSLog(@"drawingStatus:%ld",(long)drawingStatus);
    
    __weak typeof(self) tempSelf = self;
    NSTimeInterval timerInterval = 0.2f;
    switch (drawingStatus) {
        case DrawingStatusBegin:{
            [UIView animateWithDuration:timerInterval animations:^{
                CGFloat Y =  CGRectGetHeight(tempSelf.view.frame);
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.view.frame), CGRectGetHeight(tempSelf.view.frame) - Y)];
            }];
        }
            break;
        case DrawingStatusEnd:{
            CGFloat Y = CGRectGetHeight(tempSelf.view.frame)/10*9;
            [UIView animateWithDuration:timerInterval animations:^{
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.view.frame), CGRectGetHeight(tempSelf.view.frame) - Y)];
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark - EditViewDelegate
-(void)EditView:(EditView *)sender changedDrawingOption:(EditMenuTypeOptions)drawingOption{
    if (drawingOption == EditMenuTypeOptionCharacter) {
        InputCharacterViewController *inputCharacterVC = [[InputCharacterViewController alloc] init];
        inputCharacterVC.inPutCharacterDelegate = self;
        [self presentViewController:inputCharacterVC animated:YES completion:nil];
        return;
    }
    
    self.drawBoardView.drawOption = drawingOption;
    self.drawBoardView.lineColor = [UIColor redColor];
    self.drawBoardView.lineWidth = 2.f;
}

#pragma mark - InputCharacterViewControllerDelegate
-(void)InputCharacterView:(InputCharacterViewController *)inputCharacter text:(NSString *)text textColor:(UIColor *)textColor{
    [self.drawBoardView addLabelWithText:text textColor:textColor];
}

#pragma mark - Private Method

-(void)p_cancelEdit{
    if (self.drawBoardDelegate && [self.drawBoardDelegate respondsToSelector:@selector(cancelEdit)]) {
        [self.drawBoardDelegate cancelEdit];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)p_finishEdit{
    if (self.drawBoardDelegate && [self.drawBoardDelegate respondsToSelector:@selector(finishEditWithImage:)]) {
        [self.editView removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self.finishBtn removeFromSuperview];
        
        [self.drawBoardDelegate finishEditWithImage:[self p_ScreenShot]];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(UIImage *)p_ScreenShot{
    UIImage *screenCapture = nil;
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    screenCapture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenCapture;
}



#pragma mark - Get Method
-(DrawBoardView *)drawBoardView{
    if (!_drawBoardView) {
        _drawBoardView = [[DrawBoardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _drawBoardView.delegate = self;
    }
    return _drawBoardView;
}

-(EditView *)editView{
    if (!_editView) {
        CGFloat Y = CGRectGetHeight(self.view.frame)/10*9;
        _editView = [[EditView alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - Y)];
        _editView.editViewDelegate = self;
    }
    return _editView;
}

-(UIImageView *)drawBoardBackImgV{
    if (!_drawBoardBackImgV) {
        _drawBoardBackImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_drawBoardBackImgV setImage:self.drawBoardBackImg];
    }
    return _drawBoardBackImgV;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:UIColorFromRGB(0xc7c7c7)];
        [_cancelBtn.layer setCornerRadius:5.f];
        [_cancelBtn addTarget:self action:@selector(p_cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setFrame:CGRectMake(10, 20, 60, 30)];
    }
    return _cancelBtn;
}
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:UIColorFromRGB(0x56c166)];
        [_finishBtn.layer setCornerRadius:5.f];
        [_finishBtn addTarget:self action:@selector(p_finishEdit) forControlEvents:UIControlEventTouchUpInside];
        [_finishBtn setFrame:CGRectMake(SCREEN_WIDTH - 70, 20, 60, 30)];
    }
    return _finishBtn;
}


@end
