//
//  HKYDrawBoardViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/4.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYDrawBoardViewController.h"

//--------------import controller--------------------
#import "HKYInputCharacterViewController.h"

//-----------------Define View-----------------------
#import "HKYDrawBoardView.h"
#import "HKYEditView.h"
#import "HKYColorPaletteView.h"

//--------------------Model--------------------------
#import "HKYColorPaletteViewModel.h"
#import "HKYShapeMode.h"

//--------------------Other--------------------------
#import "HKYScreenShot.h"

static CGFloat colorPaletteViewShowOrDismissTimerInterval = 0.02f;

@interface HKYDrawBoardViewController ()<HKYDrawBoardViewDeletage,HKYColorPaletteViewDelegate,HKYEditViewDelegate,HKYInputCharacterViewControllerDelegate>
///取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
///确定按钮
@property (nonatomic, strong) UIButton *finishBtn;
///绘图图片容器
@property (nonatomic, strong) UIImageView *drawBoardBgImgView;
///绘图图片
@property (nonatomic, strong) UIImage *drawBoardBgImg;
///绘图区域
@property (nonatomic, strong) HKYDrawBoardView *drawBoardView;
///绘图功能选项区域(类似tabBar)
@property (nonatomic, strong) HKYEditView *editView;
///绘图面板色值、图形、及线条调整区域
@property (nonatomic, strong) HKYColorPaletteView *colorPaletteView;


///色值数据源
@property (nonatomic, strong) NSArray <UIColor *>*colorArr;
@property (nonatomic, strong) NSMutableArray <HKYShapeMode *>*rectTypeMutArr;

///选中的编辑类型  默认值：无
@property (nonatomic, assign) EditMenuTypeOptions selectedEditTypeOption;
///线条色值下标    默认值：1
@property (nonatomic, assign) NSInteger selectedColorTag;
///图形线条粗细    默认值：5.f
@property (nonatomic, assign) NSInteger rectLineW;
///画笔粗细       默认值：5.f
@property (nonatomic, assign) NSInteger lineW;
///选中的绘图图形  默认值：椭圆形
@property (nonatomic, assign) RectTypeOptions selectedRectTypeOption;
///存放编辑后的文字    默认为空
@property (nonatomic, strong) NSMutableArray <HKYTextModel*>*textModelMutArr;


@end

@implementation HKYDrawBoardViewController

-(instancetype)initWithImage:(UIImage *)backImage{
    self = [super init];
    if (self) {
        _drawBoardBgImg = backImage;
        _rectLineW = 5.f;
        _lineW = 5;
        _selectedColorTag = 1;
        _selectedRectTypeOption = RectTypeOptionEllipse;
        
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawBoardBgImgView];
    [self.drawBoardBgImgView addSubview:self.drawBoardView];
    [self.drawBoardBgImgView addSubview:self.colorPaletteView];
    [self.drawBoardBgImgView addSubview:self.editView];
    [self.drawBoardBgImgView addSubview:self.cancelBtn];
    [self.drawBoardBgImgView addSubview:self.finishBtn];
}


#pragma mark - DrawBoardViewDeletage

- (void)drawBoard:(HKYDrawBoardView *)drawView drawBoardBtnClickWithTag:(NSInteger)tag{

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
                if (tempSelf.selectedEditTypeOption == EditMenuTypeOptionLine || tempSelf.selectedEditTypeOption == EditMenuTypeOptionRect) {
                    tempSelf.colorPaletteView.y = SCREEN_HEIGHT;
                }
            }];
        }
            break;
        case DrawingStatusEnd:{
            [UIView animateWithDuration:timerInterval animations:^{
                tempSelf.editView.y = SCREEN_HEIGHT - tempSelf.editView.height;
                if (tempSelf.selectedEditTypeOption == EditMenuTypeOptionLine || tempSelf.selectedEditTypeOption == EditMenuTypeOptionRect) {
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
    if (self.selectedEditTypeOption == EditMenuTypeOptionRect) {
        self.rectLineW = lineWidth;
        self.drawBoardView.lineWidth = lineWidth;
    }else if(self.selectedEditTypeOption == EditMenuTypeOptionLine){
        self.lineW = lineWidth;
        self.drawBoardView.lineWidth = lineWidth;
    }
    
    self.drawBoardView.editTypeOption = self.selectedEditTypeOption;
    self.drawBoardView.lineColor = color;
    self.drawBoardView.rectTypeOption = rectTypeOption;
}

#pragma mark - EditViewDelegate

-(void)HKYEditView:(HKYEditView *)sender changedDrawingOption:(EditMenuTypeOptions)drawingOption{

    self.selectedEditTypeOption = drawingOption;
    self.drawBoardView.editTypeOption = drawingOption;
    
    switch (drawingOption) {
        case EditMenuTypeOptionLine:{
            [self p_showColorPaletteView];
            [self.colorPaletteView scrollToPage:0];
            self.drawBoardView.lineWidth = self.lineW;
        }
            break;
            
        case EditMenuTypeOptionRect:{
            [self p_showColorPaletteView];
            [self.colorPaletteView scrollToPage:1];
            self.drawBoardView.lineWidth = self.rectLineW;
        }
            break;
            
        case EditMenuTypeOptionEraser:{
            [self p_dismissColorPaletteView];
            self.drawBoardView.lineWidth = 10.f;
        }
            break;
            
        case EditMenuTypeOptionBack:{
            [self p_dismissColorPaletteView];
        }
            break;
            
        case EditMenuTypeOptionCharacter:{
            [self p_dismissColorPaletteView];
            HKYInputCharacterViewController *inputCharacterVC = [[HKYInputCharacterViewController alloc] initWithColorArr:self.colorArr defaultColorIndex:self.selectedColorTag];
            inputCharacterVC.inPutCharacterDelegate = self;
            [self presentViewController:inputCharacterVC animated:YES completion:nil];
        }
            break;
            
        case EditMenuTypeOptionNone:
            break;
    }
}



#pragma mark - Private Methods

-(void)p_showColorPaletteView{
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:colorPaletteViewShowOrDismissTimerInterval animations:^{
        tempSelf.colorPaletteView.y = SCREEN_HEIGHT - tempSelf.colorPaletteView.height - tempSelf.editView.height;
    }];}

-(void)p_dismissColorPaletteView{
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:colorPaletteViewShowOrDismissTimerInterval animations:^{
        tempSelf.colorPaletteView.y = SCREEN_HEIGHT;
    }];}


-(void)p_cancelEdit{
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
-(UIImageView *)drawBoardBgImgView{
    if (!_drawBoardBgImgView) {
        _drawBoardBgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_drawBoardBgImgView setImage:self.drawBoardBgImg];
        _drawBoardBgImgView.userInteractionEnabled = YES;
    }
    return _drawBoardBgImgView;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:UIColorFromRGBP(0xe5e5e5, 0.8)];
        [_cancelBtn.layer setCornerRadius:4.f];
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_cancelBtn addTarget:self action:@selector(p_cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setFrame:CGRectMake(12, 28, 69, 32)];
    }
    return _cancelBtn;
}
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:UIColorFromRGBP(0xffbf00,0.8)];
        [_finishBtn.layer setCornerRadius:4.f];
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_finishBtn addTarget:self action:@selector(p_finishEdit) forControlEvents:UIControlEventTouchUpInside];
        [_finishBtn setFrame:CGRectMake(SCREEN_WIDTH - 81, 28, 69, 32)];
    }
    return _finishBtn;
}
-(HKYDrawBoardView *)drawBoardView{
    if (!_drawBoardView) {
        _drawBoardView = [[HKYDrawBoardView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        _drawBoardView.lineWidth = self.lineW;
        _drawBoardView.lineColor = self.colorArr[self.selectedColorTag];
        _drawBoardView.rectTypeOption = self.selectedRectTypeOption;
        _drawBoardView.delegate = self;
    }
    return _drawBoardView;
}

-(HKYEditView *)editView{
    if (!_editView) {
        CGFloat editViewH = 54.f;
        CGFloat editViewY = SCREEN_HEIGHT - editViewH;
        _editView = [[HKYEditView alloc] initWithFrame:CGRectMake(0, editViewY, SCREEN_WIDTH, editViewH)];
        _editView.editViewDelegate = self;
        NSMutableArray *tempMutArr = [NSMutableArray array];
        for (int i = 0; i<5; i++) {
            HKYEditViewModel *model = [[HKYEditViewModel alloc] init];
            switch (i) {
                case 0:{
                    model.itemTitle = @"文字";
                    model.itemNormalImgName = @"icon_text_Normal_editView@3x";
                    model.itemTag = EditMenuTypeOptionCharacter;
                }
                    break;
                case 1:{
                    model.itemTitle = @"画笔";
                    model.itemNormalImgName = @"icon_pencil_Normal_editView@3x";
                    model.itemSelectedImgName = @"icon_pencil_Selected_editView@3x";
                    model.itemTag = EditMenuTypeOptionLine;
                }
                    break;
                case 2:{
                    model.itemTitle = @"图形";
                    model.itemNormalImgName = @"icon_shape_Normal_editView@3x";
                    model.itemSelectedImgName = @"icon_shape_Selected_editView@3x";
                    model.itemTag = EditMenuTypeOptionRect;
                }
                    break;
                case 3:{
                    model.itemTitle = @"擦除";
                    model.itemNormalImgName = @"icon_eraser_Normal_editView@3x";
                    model.itemSelectedImgName = @"icon_eraser_Selected_editView@3x";
                    model.itemTag = EditMenuTypeOptionEraser;
                }
                    break;
                case 4:{
                    model.itemTitle = @"回退";
                    model.itemNormalImgName = @"icon_cancel_Normal_editView@3x";
                    model.itemHighLightImgName = @"icon_cancel_highLight_editView@3x";
                    model.itemTag = EditMenuTypeOptionBack;
                }
                    break;
            }
            [tempMutArr addObject:model];
        }
        _editView.dataSource = tempMutArr;
    }
    return _editView;
}

-(HKYColorPaletteView *)colorPaletteView{
    if (!_colorPaletteView) {
        HKYColorPaletteViewModel *colorPaletteModel = [[HKYColorPaletteViewModel alloc] init];
        colorPaletteModel.colorArr = self.colorArr;
        colorPaletteModel.defaultColorIndex = self.selectedColorTag;
        colorPaletteModel.lineW = self.lineW;
        colorPaletteModel.shapesArr = self.rectTypeMutArr;
        colorPaletteModel.defaultTypeOption = self.selectedRectTypeOption;
        colorPaletteModel.rectLineW = self.rectLineW;
        
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 110);
        
        _colorPaletteView = [[HKYColorPaletteView alloc] initWithFrame:frame];
        [_colorPaletteView setupColorPaletteViewDataSource:colorPaletteModel];
        _colorPaletteView.colorPaletteViewDelegate = self;
    }
    return _colorPaletteView;
}

-(NSArray <UIColor *>*)colorArr{
    if (!_colorArr) {
        _colorArr = @[UIColorFromRGB(0xf33e0e),
                      UIColorFromRGB(0xff7f00),
                      UIColorFromRGB(0xffbf00),
                      UIColorFromRGB(0x6ad85e),
                      UIColorFromRGB(0x11d0f3),
                      UIColorFromRGB(0x00a2ff),
                      UIColorFromRGB(0xb051f2),
                      UIColorFromRGB(0x333333)];
    }
    return _colorArr;
}

-(NSMutableArray <HKYShapeMode *>*)rectTypeMutArr{
    if (!_rectTypeMutArr) {
        _rectTypeMutArr = [NSMutableArray array];
        for (int i = 0; i<3; i++) {
            HKYShapeMode *model = [[HKYShapeMode alloc] init];
            model.titleFont = [UIFont systemFontOfSize:12.f];
            model.normalTitleColor = [UIColor grayColor];
            model.selectedTitleColor = UIColorFromRGB(0x333333);
            switch (i) {
                case 0:{
                    model.title = @"箭头";
                    model.tag = RectTypeOptionArrows;
                    UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_row_shape_btn_normal@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                    UIImage *selectedImg = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_row_shape_btn_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                    model.normalImg = image;
                    model.selectedImg = selectedImg;
                }
                    break;
                case 1:{
                    model.title = @"椭圆";
                    model.tag = RectTypeOptionEllipse;
                    UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_circle_shape_btn_normal@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                    UIImage *selectedImg = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_circle_shape_btn_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                    model.normalImg = image;
                    model.selectedImg = selectedImg;
                }
                    break;
                case 2:{
                    model.title = @"矩形";
                    model.tag = RectTypeOptionSquare;
                    UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_rec_shape_btn_normal@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                    UIImage *selectedImg = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_rec_shape_btn_selected@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                    model.normalImg = image;
                    model.selectedImg = selectedImg;
                }
                    break;
                default:
                    break;
            }
            [_rectTypeMutArr addObject:model];
        }
    }
    return _rectTypeMutArr;
}


-(NSMutableArray <HKYTextModel *>*)textModelMutArr{
    if (!_textModelMutArr) {
        _textModelMutArr = [NSMutableArray array];
    }
    return _textModelMutArr;
}
    
@end
