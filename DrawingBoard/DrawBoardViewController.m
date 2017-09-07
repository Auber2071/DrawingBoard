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
#import "ColorPaletteView.h"


@interface DrawBoardViewController ()<DrawBoardViewDeletage,ColorPaletteViewDelegate,EditViewDelegate,InputCharacterViewControllerDelegate>

@property (nonatomic, strong) DrawBoardView *drawBoardView;
@property (nonatomic, strong) EditView *editView;
@property (nonatomic, strong) ColorPaletteView *colorPaletteView;

@property (nonatomic, strong) UIImageView *drawBoardBackImgV;
@property (nonatomic, strong) UIImage *drawBoardBackImg;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, assign) EditMenuTypeOptions tempOption;

@property (nonatomic, strong) NSArray *colorArr;

//初始默认值
@property (nonatomic, assign) NSInteger defaultColorTag;
@property (nonatomic, assign) NSInteger defaultLineW;
@property (nonatomic, assign) NSInteger rectWidth;

@property (nonatomic, assign) RectTypeOptions defaultRectOption;



@end

@implementation DrawBoardViewController

-(instancetype)initWithImage:(UIImage *)backImage{
    self = [super init];
    if (self) {
        _drawBoardBackImg = backImage;
        _defaultLineW = 10.f;
        _rectWidth = 5.f;
        _defaultColorTag = 1;
        _defaultRectOption = RectTypeOptionEllipse;
        
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view = self.drawBoardBackImgV;
    [self.drawBoardBackImgV addSubview:self.drawBoardView];
    [self.drawBoardBackImgV addSubview:self.colorPaletteView];
    [self.drawBoardBackImgV addSubview:self.editView];
    
    [self.drawBoardBackImgV addSubview:self.cancelBtn];
    [self.drawBoardBackImgV addSubview:self.finishBtn];
}


#pragma mark - DrawBoardViewDeletage

-(void)drawBoard:(DrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus{    
    __weak typeof(self) tempSelf = self;
    NSTimeInterval timerInterval = 0.2f;
    switch (drawingStatus) {
        case DrawingStatusBegin:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.editView.y = SCREEN_HEIGHT;
                if (tempSelf.tempOption == EditMenuTypeOptionLine || tempSelf.tempOption == EditMenuTypeOptionRect) {
                    tempSelf.colorPaletteView.y = SCREEN_HEIGHT;
                }
            }];
        }
            break;
        case DrawingStatusEnd:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.editView.y = SCREEN_HEIGHT*0.9;
                if (tempSelf.tempOption == EditMenuTypeOptionLine || tempSelf.tempOption == EditMenuTypeOptionRect) {
                    tempSelf.colorPaletteView.y = SCREEN_HEIGHT*(1- 0.1 - 0.15);
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - InputCharacterViewControllerDelegate
-(void)InputCharacterView:(InputCharacterViewController *)inputCharacter text:(NSString *)text textColor:(UIColor *)textColor{
    [self.drawBoardView addLabelWithText:text textColor:textColor];
}

#pragma mark - ColorPaletteViewDelegate
- (void)colorPaletteViewWithColor:(UIColor *)color rectTypeOption:(RectTypeOptions)rectTypeOption lineWidth:(NSUInteger)lineWidth{
    if (self.tempOption == EditMenuTypeOptionRect) {
        self.rectWidth = lineWidth;
    }else if(self.tempOption == EditMenuTypeOptionLine){
        self.defaultLineW = lineWidth;
    }
    
    self.drawBoardView.editTypeOption = self.tempOption;
    self.drawBoardView.lineColor = color;
    self.drawBoardView.lineWidth = lineWidth;
    self.drawBoardView.rectTypeOption = rectTypeOption;
}

#pragma mark - EditViewDelegate
-(void)EditView:(EditView *)sender changedDrawingOption:(EditMenuTypeOptions)drawingOption{
    self.tempOption = drawingOption;
    self.drawBoardView.editTypeOption = drawingOption;
    
    if (drawingOption == EditMenuTypeOptionLine || drawingOption == EditMenuTypeOptionRect || drawingOption == EditMenuTypeOptionEraser ) {
        self.drawBoardView.userInteractionEnabled = YES;
        self.drawBoardView.lineWidth = self.defaultLineW;
    }else{
        self.drawBoardView.userInteractionEnabled = NO;
    }
    
    __weak typeof(self) tempSelf = self;
    NSTimeInterval timerInterval = 0.2f;
    switch (drawingOption) {
        case EditMenuTypeOptionLine:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.colorPaletteView.y = SCREEN_HEIGHT*(1-0.1 - 0.15);
            }];
            [self.colorPaletteView scrollToPage:0];
            self.drawBoardView.lineWidth = self.defaultLineW;
        }
            break;
        case EditMenuTypeOptionRect:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.colorPaletteView.y = SCREEN_HEIGHT*(1-0.1 - 0.15);
            }];
            [self.colorPaletteView scrollToPage:1];
            self.drawBoardView.lineWidth = self.rectWidth;
        }
            break;
        case EditMenuTypeOptionEraser:
        case EditMenuTypeOptionBack:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.colorPaletteView.y = SCREEN_HEIGHT;
            }];
        }
            break;
        case EditMenuTypeOptionCharacter:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.colorPaletteView.y = SCREEN_HEIGHT;
            }];
            InputCharacterViewController *inputCharacterVC = [[InputCharacterViewController alloc] initWithColorArr:self.colorArr defaultColorIndex:self.defaultColorTag];
            inputCharacterVC.inPutCharacterDelegate = self;
            [self presentViewController:inputCharacterVC animated:YES completion:nil];
        }
            break;
    }
}

#pragma mark - Private Methods

-(void)p_cancelEdit{
    if (self.drawBoardDelegate && [self.drawBoardDelegate respondsToSelector:@selector(cancelEdit)]) {
        [self.drawBoardDelegate cancelEdit];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)p_finishEdit{
    if (self.drawBoardDelegate && [self.drawBoardDelegate respondsToSelector:@selector(finishEditWithImage:)]) {
        
        [self.colorPaletteView removeFromSuperview];
        [self.editView removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self.finishBtn removeFromSuperview];
        self.colorPaletteView = nil;
        self.editView = nil;
        self.cancelBtn = nil;
        self.finishBtn = nil;
        
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
-(UIImageView *)drawBoardBackImgV{
    if (!_drawBoardBackImgV) {
        _drawBoardBackImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_drawBoardBackImgV setImage:self.drawBoardBackImg];
        _drawBoardBackImgV.userInteractionEnabled = YES;
    }
    return _drawBoardBackImgV;
}

-(DrawBoardView *)drawBoardView{
    if (!_drawBoardView) {
        _drawBoardView = [[DrawBoardView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        _drawBoardView.userInteractionEnabled = NO;
        _drawBoardView.lineWidth = self.defaultLineW;
        _drawBoardView.lineColor = self.colorArr[self.defaultColorTag];
        _drawBoardView.rectTypeOption = self.defaultRectOption;
        _drawBoardView.delegate = self;
    }
    return _drawBoardView;
}

-(EditView *)editView{
    if (!_editView) {
        CGFloat Y = SCREEN_HEIGHT*0.9;
        _editView = [[EditView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, SCREEN_HEIGHT*0.1)];
        _editView.editViewDelegate = self;
    }
    return _editView;
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

-(ColorPaletteView *)colorPaletteView{
    if (!_colorPaletteView) {
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.15);
        _colorPaletteView = [[ColorPaletteView alloc] initWithFrame:frame
                                                           ColorArr:self.colorArr
                                                  defaultColorIndex:self.defaultColorTag
                                                   defaultLineWidth:self.defaultLineW
                                              defaultRectTypeOption:self.defaultRectOption defaultRectWidth:self.rectWidth];
        _colorPaletteView.colorPaletteViewDelegate = self;
    }
    return _colorPaletteView;
}


-(NSArray *)colorArr{
    if (!_colorArr) {
        _colorArr = @[[UIColor blackColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor purpleColor]];
    }
    return _colorArr;
}

@end
