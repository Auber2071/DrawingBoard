//
//  ShareAndEditPhotoView.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/1.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "ShareAndEditPhotoView.h"

typedef enum : NSUInteger {
    quitShareAndEditViewOption,
    EditPhotoOption,
    SharePhotoOption,
} BtnOption;

static NSTimeInterval  const duration = 0.1f;

@interface ShareAndEditPhotoView ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnMutArr;


@end

@implementation ShareAndEditPhotoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/5.f)];
        _btnMutArr = [NSMutableArray array];
        [self p_addBtn];
    }
    return self;
}


-(void)layoutSubviews{
    CGFloat padding = 50.f;
    CGFloat btnW = (CGRectGetWidth(self.frame) - padding*(self.btnMutArr.count+1))/self.btnMutArr.count;
    CGFloat btnH = btnW;
    
    for (int i = 0; i< self.btnMutArr.count; i++) {
        UIButton *tempBtn = self.btnMutArr[i];
        [tempBtn setFrame:CGRectMake(padding+i*(padding+btnW), (CGRectGetHeight(self.frame)-btnH)/2.f, btnW, btnH)];
        tempBtn.layer.cornerRadius = btnW/2.f;
        tempBtn.layer.masksToBounds = YES;
    }
}

-(void)p_addBtn{
    
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(p_clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i;
        switch (i) {
            case 0:{
                button.tag = quitShareAndEditViewOption;
                //[button setBackgroundColor:[UIColor lightGrayColor]];
                [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
            }
                break;
            case 1:{
                button.tag = EditPhotoOption;
                //[button setBackgroundColor:[UIColor lightGrayColor]];
                [button setBackgroundImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
            }
                break;
            case 2:{
                button.tag = SharePhotoOption;
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setBackgroundImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
            }
                break;
        }
        [self.btnMutArr addObject:button];
        [self addSubview:button];
    }
}



-(void)p_clickButton:(UIButton *)sender{
    [self dismissShareAndEditView];
    
    switch (sender.tag) {
        case quitShareAndEditViewOption:{//返回
            if (self.shareAndEditDelegate && [self.shareAndEditDelegate respondsToSelector:@selector(back)]) {
                [self.shareAndEditDelegate back];
            }
        }
            break;
        case EditPhotoOption:{//画板面板弹出
            if (self.shareAndEditDelegate && [self.shareAndEditDelegate respondsToSelector:@selector(EditPhoto)]) {
                [self.shareAndEditDelegate EditPhoto];
            }
        }
            break;
        case SharePhotoOption:{//分享
            if (self.shareAndEditDelegate && [self.shareAndEditDelegate respondsToSelector:@selector(shareImage)]) {
                [self.shareAndEditDelegate shareImage];
            }
        }
            break;
    }
}

-(void)showShareAndEditView{
    if (CGRectGetMinY(self.frame) < [[UIScreen mainScreen] bounds].size.height) {
        return;
    }
    
    [UIView animateWithDuration:duration animations:^{
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = ([[UIScreen mainScreen] bounds].size.height/6.f)*5;
        self.frame = tempFrame;
    }];
}

-(void)dismissShareAndEditView{
    if (CGRectGetMinY(self.frame)>=[[UIScreen mainScreen] bounds].size.height) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        self.frame = tempFrame;
    }];
}



@end
