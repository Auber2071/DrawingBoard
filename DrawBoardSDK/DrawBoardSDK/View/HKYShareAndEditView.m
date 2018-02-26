//
//  HKYShareAndEditView.m
//  DrawBoardSDK
//
//  Created by hankai on 2017/9/19.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYShareAndEditView.h"

typedef enum : NSUInteger {
    quitShareAndEditViewOption,
    EditPhotoOption,
    SharePhotoOption,
} BtnOption;

@interface HKYShareAndEditView ()
@property (nonatomic, strong) NSMutableArray *btnMutArr;

@end

@implementation HKYShareAndEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_addBtn];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat padding = 0.12*CGRectGetWidth(self.frame);
    CGFloat btnW = (CGRectGetWidth(self.frame) - padding*(self.btnMutArr.count+1))/self.btnMutArr.count;
    for (int i = 0; i<self.btnMutArr.count; i++) {
        UIButton *tempBtn = self.btnMutArr[i];
        [tempBtn setFrame:CGRectMake(padding+i*(padding+btnW), (CGRectGetHeight(self.frame)-btnW)/2.f, btnW, btnW)];
        tempBtn.layer.cornerRadius = btnW/2.f;
        tempBtn.layer.masksToBounds = YES;

    }
}

-(void)p_addBtn{
    CGFloat btnCount = 3;
    for (int i = 0; i<btnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(p_clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        switch (i) {
            case 0:{
                button.tag = quitShareAndEditViewOption;
                /*
                 //这个Class对应你工程所在的类名
                 [[NSBundle bundleForClass:self.class] loadNibNamed:@"ColorView" owner:self options:nil];
                 //这个对应你的FrameWork的Bundle Identifier
                 [[NSBundle bundleWithIdentifier:@"com.xxx.xx"] loadNibNamed:@"ColorView" owner:self options:nil];
                 //或
                 UIImage *image =  [UIImage imageNamed:@"返回" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
                 //或
                 NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"APPBaseSDKBundle" withExtension:@"bundle"]];
                 UIImage *iv = [UIImage imageNamed:@"zhuanqian" inBundle:bundle compatibleWithTraitCollection:nil];
                 //或
                 UIImageView *v2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,100, 50, 50)];
                 v2.image = [UIImage imageNamed:@"APPBaseSDKBundle.bundle/zhuanqian"];
                 */
                UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"fanhui@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                [button setBackgroundImage:image forState:UIControlStateNormal];
            }
                break;
            case 1:{
                button.tag = EditPhotoOption;
                UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"bianji@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                [button setBackgroundImage:image forState:UIControlStateNormal];
            }
                break;
            case 2:{
                button.tag = SharePhotoOption;
                [button setBackgroundColor:[UIColor whiteColor]];
                UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"duihao@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
                [button setBackgroundImage:image forState:UIControlStateNormal];
            }
                break;
        }
        [self.btnMutArr addObject:button];
        [self addSubview:button];
    }
}


-(void)p_clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case quitShareAndEditViewOption:{//返回
            if (self.shareAndEditViewDelegate && [self.shareAndEditViewDelegate respondsToSelector:@selector(cancleAction)]) {
                [self.shareAndEditViewDelegate cancleAction];
            }
        }
            break;
        case EditPhotoOption:{//画板面板弹出
            if (self.shareAndEditViewDelegate && [self.shareAndEditViewDelegate respondsToSelector:@selector(editAction)]) {
                [self.shareAndEditViewDelegate editAction];
            }
        }
            break;
        case SharePhotoOption:{//分享
            if (self.shareAndEditViewDelegate && [self.shareAndEditViewDelegate respondsToSelector:@selector(shareAction)]) {
                [self.shareAndEditViewDelegate shareAction];
            }
        }
            break;
    }
}


-(NSMutableArray *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = [NSMutableArray array];
    }
    return _btnMutArr;
}
@end
