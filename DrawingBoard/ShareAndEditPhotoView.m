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
        [self setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/6.f)];
        _btnMutArr = [NSMutableArray array];
        [self p_addBtn];
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat padding = 20.f;
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
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button addTarget:self action:@selector(p_clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i;
        switch (i) {
            case 0:{
                button.tag = quitShareAndEditViewOption;
                [button setTitle:@"退出" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
                break;
            case 1:{
                button.tag = EditPhotoOption;
                [button setTitle:@"编辑" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
                break;
            case 2:{
                button.tag = SharePhotoOption;
                [button setTitle:@"分享" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
                break;
        }
        [self.btnMutArr addObject:button];
        [self addSubview:button];
    }
}

-(void)p_clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case quitShareAndEditViewOption:{
            [UIView animateWithDuration:duration animations:^{
                CGRect tempFrame = self.frame;
                tempFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
                self.frame = tempFrame;
            }];
        }
            break;
        case EditPhotoOption:{

        }
            break;
        case SharePhotoOption:{
            [self p_ScreenShot];
        }
            break;
    }
}


-(void)showShareAndEditView{
    [UIView animateWithDuration:duration animations:^{
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = ([[UIScreen mainScreen] bounds].size.height/6.f)*5;
        self.frame = tempFrame;
    }];
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


@end
