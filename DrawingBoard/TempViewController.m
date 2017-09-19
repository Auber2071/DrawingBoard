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
    HKYShareAndEditPhotoViewController *shareAndEditPhotoVC = [[HKYShareAndEditPhotoViewController alloc]initWithImage:[[HKYScreenShot shareScreenShot] screenShot]];
    [self presentViewController:shareAndEditPhotoVC animated:NO completion:nil];
}

@end
