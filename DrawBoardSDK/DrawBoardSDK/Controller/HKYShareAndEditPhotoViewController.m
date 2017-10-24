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
#import "BNCUMShare.h"

static NSTimeInterval  const duration = 0.1f;

@interface HKYShareAndEditPhotoViewController ()<HKYShareAndEditViewDelegate,HKYDrawBoardViewControllerDelegaete>

@property (nonatomic, strong) HKYShareAndEditView *shareAndEditView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImage *shareImage;

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

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backImageView.userInteractionEnabled = YES;
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
        BNCUMShare *shareView = [BNCUMShare shareWithUMShare];
        [shareView shareImg:self.shareImage];
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
    if (self.shareAndEditView.y < SCREEN_HEIGHT) {
        return;
    }
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:duration animations:^{
        tempSelf.shareAndEditView.y = (SCREEN_HEIGHT/6.f)*5;
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
    }
    return _backImageView;
}

@end
