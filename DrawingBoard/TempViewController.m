//
//  TempViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/1.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TempViewController.h"


#import "DrawBoard.h"
#import "ShareAndEditPhotoView.h"

@interface TempViewController ()<shareAndEditPhotoViewDelegate,DrawBoardDelegate>
@property (nonatomic, strong) DrawBoard *drawBoard;
@property (nonatomic, strong) UIImageView *backImageView;



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
    //[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
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

-(void)EditPhoto{

    [self.navigationController.navigationBar setHidden:YES];
    [self.view addSubview:self.drawBoard];
    [UIView animateWithDuration:0.5f animations:^{
        [self.drawBoard setFrame:self.view.bounds];
    }];
}


#pragma mark - DrawBoardDelegate
-(void)cancelEdit{
    [self.navigationController.navigationBar setHidden:NO];
    if ([self.view.subviews containsObject:self.drawBoard]) {
        self.drawBoard.drawBoardDelegate = nil;
        [self.drawBoard removeFromSuperview];
        self.drawBoard = nil;
    }
    [self.shareAndEditView showShareAndEditView];

}

-(void)finishEditWithImage:(UIImage *)finishImage{
    [self.backImageView setImage:finishImage];
    
    [self.navigationController.navigationBar setHidden:NO];
    if ([self.view.subviews containsObject:self.drawBoard]) {
        self.drawBoard.drawBoardDelegate = nil;
        [self.drawBoard removeFromSuperview];
        self.drawBoard = nil;
    }
    [self.shareAndEditView showShareAndEditView];
}




-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView =  [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setImage:[UIImage imageNamed:@"background"]];
    }
    return _backImageView;
}

-(DrawBoard *)drawBoard{
    if (!_drawBoard) {
        _drawBoard = [[DrawBoard alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _drawBoard.drawBoardDelegate = self;
    }
    return _drawBoard;
}

@end
