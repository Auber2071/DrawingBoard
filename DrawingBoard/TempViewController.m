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

@interface TempViewController ()
@property (nonatomic, strong) DrawBoard *drawBoard;
@property (nonatomic, strong) UIImageView *backImageView;



@property (nonatomic, strong) ShareAndEditPhotoView *shareAndEditView ;

@end

@implementation TempViewController
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView =  [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setImage:[UIImage imageNamed:@"background"]];
    }
    return _backImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backImageView];
    
    [self p_designNavigation];
    [self p_addShareAndEditView];
    
    //[self.view addSubview:self.drawBoard];
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

-(void)p_addShareAndEditView{
    self.shareAndEditView = [[ShareAndEditPhotoView alloc] init];
    [self.view addSubview:self.shareAndEditView];
}


-(void)showEditView:(UIButton *)sender{
    [self.shareAndEditView showShareAndEditView];
}



-(DrawBoard *)drawBoard{
    if (!_drawBoard) {
        _drawBoard = [[DrawBoard alloc] initWithFrame:self.view.bounds];
    }
    return _drawBoard;
}
@end
