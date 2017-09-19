//
//  HKYDrawBoardViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/4.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYDrawBoardViewController.h"
#import "HKYInputCharacterViewController.h"

#import "HKYDrawBoardView.h"
#import "HKYEditView.h"
#import "HKYColorPaletteView.h"
#import "HKYScreenShot.h"


@interface HKYDrawBoardViewController ()<HKYDrawBoardViewDeletage,HKYColorPaletteViewDelegate,HKYEditViewDelegate,HKYInputCharacterViewControllerDelegate>

@property (nonatomic, strong) HKYDrawBoardView *drawBoardView;
@property (nonatomic, strong) HKYEditView *editView;
@property (nonatomic, strong) HKYColorPaletteView *colorPaletteView;

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

@property (nonatomic, strong) NSMutableArray *textModelMutArr;


@end

@implementation HKYDrawBoardViewController

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

-(void)drawBoardBtnClickWithTag:(NSInteger)tag{

    for (HKYTextModel *textModel in self.textModelMutArr) {
        if (textModel.tag == tag) {
            HKYInputCharacterViewController *inputCharacterVC = [[HKYInputCharacterViewController alloc] initWithColorArr:self.colorArr defaultColorIndex:textModel.textColorIndex];
            inputCharacterVC.inPutCharacterDelegate = self;
            textModel.isFixed = YES;
            inputCharacterVC.fixedTextModel = textModel;
            [self presentViewController:inputCharacterVC animated:YES completion:nil];

        }
    }
    
    
    
}

-(void)drawBoard:(HKYDrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus{
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
                tempSelf.editView.y = SCREEN_HEIGHT - tempSelf.editView.height;
                if (tempSelf.tempOption == EditMenuTypeOptionLine || tempSelf.tempOption == EditMenuTypeOptionRect) {
                    tempSelf.colorPaletteView.y = SCREEN_HEIGHT - tempSelf.colorPaletteView.height - tempSelf.editView.height;
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - InputCharacterViewControllerDelegate
-(void)InputCharacterView:(HKYInputCharacterViewController *)inputCharacter textModel:(HKYTextModel *)textModel{
    if (!textModel.isFixed) {
        [self.textModelMutArr addObject:textModel];
    }
    [self.drawBoardView setupLabelWithTextModel:textModel];
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
-(void)HKYEditView:(HKYEditView *)sender changedDrawingOption:(EditMenuTypeOptions)drawingOption{
    self.tempOption = drawingOption;
    self.drawBoardView.editTypeOption = drawingOption;
    
    if (drawingOption == EditMenuTypeOptionLine || drawingOption == EditMenuTypeOptionRect || drawingOption == EditMenuTypeOptionEraser ) {
        self.drawBoardView.lineWidth = self.defaultLineW;
    }
    
    
    switch (drawingOption) {
        case EditMenuTypeOptionLine:{
            [self p_showColorPaletteView];
            [self.colorPaletteView scrollToPage:0];
            self.drawBoardView.lineWidth = self.defaultLineW;
        }
            break;
        case EditMenuTypeOptionRect:{
            [self p_showColorPaletteView];
            
            [self.colorPaletteView scrollToPage:1];
            self.drawBoardView.lineWidth = self.rectWidth;
        }
            break;
        case EditMenuTypeOptionEraser:
        case EditMenuTypeOptionBack:{
            [self p_dismissColorPaletteView];
        }
            break;
        case EditMenuTypeOptionCharacter:{
            [self p_dismissColorPaletteView];
            
            HKYInputCharacterViewController *inputCharacterVC = [[HKYInputCharacterViewController alloc] initWithColorArr:self.colorArr defaultColorIndex:self.defaultColorTag];
            inputCharacterVC.inPutCharacterDelegate = self;
            [self presentViewController:inputCharacterVC animated:YES completion:nil];
        }
            break;
    }
}



#pragma mark - Private Methods

-(void)p_showColorPaletteView{
    NSTimeInterval timerInterval = 0.2f;
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:timerInterval animations:^{
        tempSelf.colorPaletteView.y = SCREEN_HEIGHT - tempSelf.colorPaletteView.height - tempSelf.editView.height;
    }];}

-(void)p_dismissColorPaletteView{
    NSTimeInterval timerInterval = 0.2f;
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:timerInterval animations:^{
        tempSelf.colorPaletteView.y = SCREEN_HEIGHT;
    }];}


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
        
        [self.drawBoardDelegate finishEditWithImage:[[HKYScreenShot shareScreenShot] screenShot]];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
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

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:UIColorFromRGBP(0Xafafaf, 0.7)];
        [_cancelBtn.layer setCornerRadius:4.f];
        [_cancelBtn addTarget:self action:@selector(p_cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setFrame:CGRectMake(12, 10, 69, 32)];
    }
    return _cancelBtn;
}
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:UIColorFromRGBP(0x0fa424,0.7)];
        [_finishBtn.layer setCornerRadius:4.f];
        [_finishBtn addTarget:self action:@selector(p_finishEdit) forControlEvents:UIControlEventTouchUpInside];
        [_finishBtn setFrame:CGRectMake(SCREEN_WIDTH - 81, 10, 69, 32)];
    }
    return _finishBtn;
}
-(HKYDrawBoardView *)drawBoardView{
    if (!_drawBoardView) {
        _drawBoardView = [[HKYDrawBoardView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        _drawBoardView.userInteractionEnabled = NO;
        _drawBoardView.lineWidth = self.defaultLineW;
        _drawBoardView.lineColor = self.colorArr[self.defaultColorTag];
        _drawBoardView.rectTypeOption = self.defaultRectOption;
        _drawBoardView.delegate = self;
    }
    return _drawBoardView;
}

-(HKYEditView *)editView{
    if (!_editView) {
        CGFloat height = 49.f;
        CGFloat Y = SCREEN_HEIGHT - height;
        _editView = [[HKYEditView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, height)];
        _editView.editViewDelegate = self;
    }
    return _editView;
}
-(HKYColorPaletteView *)colorPaletteView{
    if (!_colorPaletteView) {
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 83);
        _colorPaletteView = [[HKYColorPaletteView alloc] initWithFrame:frame
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
        _colorArr = @[UIColorFromRGB(0x030303),UIColorFromRGB(0xff2d20),UIColorFromRGB(0x0064df),UIColorFromRGB(0x35d800),UIColorFromRGB(0xead709),UIColorFromRGB(0xc340bb)];
    }
    return _colorArr;
}
-(NSMutableArray *)textModelMutArr{
    if (!_textModelMutArr) {
        _textModelMutArr = [NSMutableArray array];
    }
    return _textModelMutArr;
}
@end
