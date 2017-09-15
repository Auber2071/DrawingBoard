//
//  TempViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/1.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TempViewController.h"
#import <DrawBoardSDK/DrawBoardSDK.h>

@implementation TempViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView =  [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled = YES;
    [imageView setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:imageView];

    
    
    [self p_designNavigation];
}


-(void)p_designNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    //rightNaviItem
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"icon-fx"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(showEditView:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(0, 0, 60, 40)];
    UIBarButtonItem *shareBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarBtnItem;
}




-(void)showEditView:(UIButton *)sender{
    ShareAndEditPhotoViewController *shareAndEditPhotoVC = [[ShareAndEditPhotoViewController alloc]initWithImage:[self p_ScreenShot]];
    [self presentViewController:shareAndEditPhotoVC animated:NO completion:nil];
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
