//
//  TempViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/1.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TempViewController.h"
#import "ShareAndEditPhotoView.h"
#import "DrawBoardViewController.h"

#import "BNCUMShare.h"


@interface TempViewController ()<shareAndEditPhotoViewDelegate,DrawBoardViewControllerDelegaete>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) BNCUMShare *shareView;



@property (nonatomic, strong) ShareAndEditPhotoView *shareAndEditView ;

@end

@implementation TempViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backImageView];

    [self p_designNavigation];
    [self p_addShareAndEditView];

}

-(void)p_addShareAndEditView{
    self.shareAndEditView = [[ShareAndEditPhotoView alloc] init];
    self.shareAndEditView.shareAndEditDelegate = self;
    [self.view addSubview:self.shareAndEditView];
}

-(void)p_designNavigation{
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    //rightNaviItem
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"icon-fx"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(showEditView:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(0, 0, 60, 40)];
    UIBarButtonItem *shareBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarBtnItem;
}




-(void)showEditView:(UIButton *)sender{
    [self.shareAndEditView showShareAndEditView];
}





#pragma mark - shareAndEditPhotoViewDelegate
-(void)back{
    [self.backImageView setImage:[UIImage imageNamed:@"background"]];
}

-(void)EditPhoto{
    DrawBoardViewController *drawBoardVC = [[DrawBoardViewController alloc] initWithImage:self.backImage];
    drawBoardVC.drawBoardDelegate = self;
    [self presentViewController:drawBoardVC animated:NO completion:nil];
}

-(void)shareImage{
    self.shareView = [BNCUMShare shareWithUMShare];
    [self.shareView shareImg:[self p_ScreenShot]];
}


#pragma mark - DrawBoardViewControllerDelegaete
-(void)cancelEdit{
    [self.shareAndEditView showShareAndEditView];
}

-(void)finishEditWithImage:(UIImage *)finishImage{
    self.backImage = finishImage;
    [self.backImageView setImage:finishImage];
    [self.shareAndEditView showShareAndEditView];
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

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView =  [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setImage:self.backImage];
    }
    return _backImageView;
}

-(UIImage *)backImage{
    if (!_backImage) {
        _backImage = [UIImage imageNamed:@"background"];
    }
    return _backImage;
}
@end
