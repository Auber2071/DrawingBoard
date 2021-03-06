//
//  HKYInputCharacterViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/5.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYInputCharacterViewController.h"
#import "HKYTextModel.h"


@interface HKYInputCharacterViewController ()
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIScrollView *colorBackGroundView;
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, assign) NSInteger defaultColorIndex;


@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, assign) UIEdgeInsets buttonInset;
@property (nonatomic, assign) CGFloat normalWidth;
@property (nonatomic, assign) CGFloat largeWidth;
@property (nonatomic, assign) CGFloat padding;


@end

@implementation HKYInputCharacterViewController

- (instancetype)initWithColorArr:(NSArray *)colorArr defaultColorIndex:(NSInteger)defaultColorIndex{
    self = [super init];
    if (self) {
        _colorArr = colorArr;
        _defaultColorIndex = defaultColorIndex;
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.colorBackGroundView];
    [self p_addColorOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.textView becomeFirstResponder];
}

-(void)p_addColorOptions{
    self.buttonInset = UIEdgeInsetsMake(0, SCREEN_WIDTH*0.074, 0, SCREEN_WIDTH*0.074);
    self.normalWidth = 0.07*SCREEN_WIDTH;
    self.largeWidth = 0.1*SCREEN_WIDTH;
    self.padding = (SCREEN_WIDTH - self.buttonInset.left - self.buttonInset.right - self.normalWidth*self.colorArr.count)/(self.colorArr.count-1);

    
    for (int i = 0; i<self.colorArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:self.colorArr[i]];
        [button setFrame:CGRectMake(0, 0, self.normalWidth, self.normalWidth)];
        
        button.center = CGPointMake(self.buttonInset.left+self.normalWidth/2.f +i*(self.normalWidth+self.padding), CGRectGetHeight(self.colorBackGroundView.frame)/2.f);
        
        button.layer.cornerRadius = button.size.width/2.f;
        
        button.tag = (NSInteger)i;
        [button addTarget:self action:@selector(p_clickColorOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorBackGroundView addSubview:button];
        
        if (i == _defaultColorIndex) {
            self.lastBtn = button;
            button.selected = YES;
            [self p_reserBtnFrameWithButton:button isLast:NO tag:(NSUInteger)i];
        }
    }
}


-(void)p_clickColorOption:(UIButton *)sender{
    self.textView.textColor = self.colorArr[sender.tag];
    if (!sender.isSelected) {
        self.lastBtn.selected = !self.lastBtn.selected;
        sender.selected = !sender.selected;
        
        [self p_reserBtnFrameWithButton:sender isLast:NO tag:sender.tag];
        [self p_reserBtnFrameWithButton:self.lastBtn isLast:YES tag:self.lastBtn.tag];
        self.lastBtn = sender;
    }
}

-(void)p_reserBtnFrameWithButton:(UIButton *)sender isLast:(BOOL)isLast tag:(NSInteger)tag{
    if (isLast) {
        sender.size = CGSizeMake(self.normalWidth, self.normalWidth);
    }else{
        sender.size = CGSizeMake(self.largeWidth, self.largeWidth);
    }
    sender.layer.cornerRadius = sender.size.width/2.f;
    sender.center = CGPointMake(self.buttonInset.left+self.normalWidth/2.f +tag*(self.normalWidth+self.padding), CGRectGetHeight(self.colorBackGroundView.frame)/2.f);
}


-(void)p_cancelClick{
    [self p_resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)p_finishClick{
    [self p_resignFirstResponder];
    if (self.inPutCharacterDelegate && [self.inPutCharacterDelegate respondsToSelector:@selector(InputCharacterView:textModel:)]) {

        self.fixedTextModel.text = self.textView.text;
        self.fixedTextModel.textColor = self.textView.textColor;
        self.fixedTextModel.textColorIndex = self.lastBtn.tag;
        [self.inPutCharacterDelegate InputCharacterView:self textModel:self.fixedTextModel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)p_keyBoardShow:(NSNotification *)notification{
    NSDictionary *tempDict = notification.userInfo;
    NSValue *beginFrame = [tempDict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardBeginFrame = [beginFrame CGRectValue];
    
    CGFloat differenceValue = CGRectGetMaxY(self.colorBackGroundView.frame) - CGRectGetMinY(keyBoardBeginFrame);
    
    NSValue *animationDurationValue = [tempDict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect tempFrame = self.textView.frame;
        tempFrame.size.height -= differenceValue;
        self.textView.frame = tempFrame;
        self.colorBackGroundView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT*0.1);
    }];
}

-(void)p_resignFirstResponder{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - Get Method

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:UIColorFromRGBP(0xe5e5e5, 0.8)];
        [_cancelBtn.layer setCornerRadius:4.f];
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_cancelBtn addTarget:self action:@selector(p_cancelClick) forControlEvents:UIControlEventTouchUpInside];
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
        [_finishBtn addTarget:self action:@selector(p_finishClick) forControlEvents:UIControlEventTouchUpInside];
        [_finishBtn setFrame:CGRectMake(SCREEN_WIDTH - 81, 28, 69, 32)];
    }
    return _finishBtn;
}

-(UITextView *)textView{
    if (!_textView) {
        UIEdgeInsets textViewInset = UIEdgeInsetsMake(10, 20, 0, 20);
        CGFloat width = SCREEN_WIDTH - textViewInset.left - textViewInset.right;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewInset.left, CGRectGetMaxY(self.cancelBtn.frame)+textViewInset.top, width, SCREEN_HEIGHT/2.f)];
        _textView.backgroundColor = UIColorFromRGB(0xfafafa);
        _textView.font = [UIFont systemFontOfSize:16.f];
        _textView.text = self.fixedTextModel.text;
        _textView.textColor = self.fixedTextModel.textColor;;
        _textView.layer.cornerRadius = 5.f;
    }
    return _textView;
}

-(UIScrollView *)colorBackGroundView{
    if (!_colorBackGroundView) {
        _colorBackGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT*0.1)];
        _colorBackGroundView.showsHorizontalScrollIndicator = NO;
        _colorBackGroundView.backgroundColor = [UIColor lightGrayColor];
    }
    return _colorBackGroundView;
}


-(HKYTextModel *)fixedTextModel{
    if (!_fixedTextModel) {
        _fixedTextModel = [[HKYTextModel alloc] init];
        _fixedTextModel.text = @"";
        _fixedTextModel.textColor = self.colorArr[self.defaultColorIndex];
        _fixedTextModel.isFixed = NO;
        _fixedTextModel.textColorIndex = self.defaultColorIndex;
    }
    return _fixedTextModel;
}

@end
