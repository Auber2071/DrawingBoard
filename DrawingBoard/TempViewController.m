//
//  TempViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/1.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TempViewController.h"
#import <DrawBoardSDK/DrawBoardSDK.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TempViewController()<HKYShareAndEditPhotoViewControllerDelegate,HKYUMShareDelegate>
@property (nonatomic, strong) HKYShareAndEditPhotoViewController *shareAndEditPhotoVC;

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    //rightNaviItem
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"icon-fx"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(showEditView:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(0, 0, 60, 40)];
    UIBarButtonItem *shareBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarBtnItem;
}


///吊起批注分享功能
-(void)showEditView:(UIButton *)sender{
    self.shareAndEditPhotoVC = [[HKYShareAndEditPhotoViewController alloc]initWithImage:[[HKYScreenShot shareScreenShot] screenShot]];
    self.shareAndEditPhotoVC.viewController = self;
    //    self.shareAndEditPhotoVC.delegate = self;
    [self presentViewController:self.shareAndEditPhotoVC animated:NO completion:nil];
}


-(void)shareBtnClick{
    HKYUMShare *shareView = [HKYUMShare shareWithUMShare];
    shareView.platTypeOrder = @[@(HKYUMSocialPlatformType_WechatSession),
                                @(HKYUMSocialPlatformType_QQ),
                                //                                @(HKYUMSocialPlatformType_Sina),
                                @(HKYUMSocialPlatformType_WechatTimeLine),
                                @(HKYUMSocialPlatformType_Qzone),
                                @(HKYUMSocialPlatformType_WechatFavorite),
                                @(HKYUMSocialPlatformType_Sms),
                                @(HKYUMSocialPlatformType_Email)
                                ];
    
    shareView.bncShareDelegate = self;
    [shareView shareImg:self.shareAndEditPhotoVC.shareImage];
}

@end

