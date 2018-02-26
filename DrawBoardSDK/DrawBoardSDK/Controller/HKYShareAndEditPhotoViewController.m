//
//  HKYShareAndEditPhotoViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYShareAndEditPhotoViewController.h"
#import "HKYShareAndEditView.h"
#import "HKYDrawBoardViewController.h"
#import "HKYUMShare.h"
#import "HKYSystemShare.h"

static NSTimeInterval  const duration = 0.1f;

@interface HKYShareAndEditPhotoViewController ()<HKYShareAndEditViewDelegate,HKYDrawBoardViewControllerDelegaete,HKYUMShareDelegate>

@property (nonatomic, strong) HKYShareAndEditView *shareAndEditView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong, readwrite) UIImage *shareImage;
@property (nonatomic, assign) BOOL isOpenLog;

@end

@implementation HKYShareAndEditPhotoViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        _shareImage = [image copy];
        [self.view addSubview:self.backImageView];
        [self.view addSubview:self.shareAndEditView];
    }
    return self;
}

- (void)openLog:(BOOL)logOnOff{
    _isOpenLog = logOnOff;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.sharePlatformType = HKYSystemPlatformShare;
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self p_showShareAndEditView];
}

#pragma mark - HKYShareAndEditViewDelegate

-(void)cancleAction{
    [self p_dismissShareAndEditView];
}

-(void)editAction{
    self.backImageView.userInteractionEnabled = NO;
    HKYDrawBoardViewController *drawBoardVC = [[HKYDrawBoardViewController alloc] initWithImage:self.shareImage];
    drawBoardVC.drawBoardDelegate = self;
    [self presentViewController:drawBoardVC animated:NO completion:nil];
}

-(void)shareAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareBtnClick)]) {
        [self.delegate shareBtnClick];
    }else{
        switch (self.sharePlatformType) {
            case HKYUMSocialPlatformShare:{
                HKYUMShare *shareView = [HKYUMShare shareWithUMShare];
                shareView.bncShareDelegate = self;
                [shareView openLog:self.isOpenLog];
                [shareView shareImg:self.shareImage];
            }
                break;
                
            case HKYSystemPlatformShare:{
                HKYSystemShare *systemShare = [[HKYSystemShare alloc] init];
                [systemShare openLog:self.isOpenLog];
                [systemShare shareWithSourceController:self.viewController Items:@[self.shareImage]];
            }
                break;
            default:
                break;
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark - DrawBoardViewControllerDelegaete

-(void)finishEditWithImage:(UIImage *)finishImage{
    self.backImageView.userInteractionEnabled = YES;
    self.shareImage = finishImage;
    [self.backImageView setImage:self.shareImage];
    
    [self p_showShareAndEditView];
}



#pragma mark - Private Method

-(void)p_showShareAndEditView{
    CGFloat tempY = (SCREEN_HEIGHT/6.f)*5;
    if (self.shareAndEditView.y == tempY) {
        return;
    }
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:duration animations:^{
        tempSelf.shareAndEditView.y = tempY;
    }];
}

-(void)p_dismissShareAndEditView{
    if (self.shareAndEditView.y>=SCREEN_HEIGHT) {
        return;
    }
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:duration animations:^{
        tempSelf.shareAndEditView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}



#pragma mark - Get Method

-(HKYShareAndEditView *)shareAndEditView{
    if (!_shareAndEditView) {
        _shareAndEditView = [[HKYShareAndEditView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/6.f)];
        _shareAndEditView.shareAndEditViewDelegate = self;
    }
    return _shareAndEditView;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backImageView.image = self.shareImage;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

@end
