//
//  ShareAndEditPhotoViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/9/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "ShareAndEditPhotoViewController.h"

#import "DrawBoardViewController.h"
#import "BNCUMShare.h"

typedef enum : NSUInteger {
    quitShareAndEditViewOption,
    EditPhotoOption,
    SharePhotoOption,
} BtnOption;

static NSTimeInterval  const duration = 0.1f;

@interface ShareAndEditPhotoViewController ()<DrawBoardViewControllerDelegaete>

@property (nonatomic, strong) NSMutableArray<UIButton *> *btnMutArr;
@property (nonatomic, strong) UIView *editBackView;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) UIImageView *backImageView;


@end

@implementation ShareAndEditPhotoViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _shareImg = [image copy];
        [self.view setBackgroundColor:[UIColor clearColor]];
        _btnMutArr = [NSMutableArray array];
        [self.view addSubview:self.backImageView];
        [self.view addSubview:self.editBackView];
        [self p_addBtn];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showShareAndEditView];
}
-(UIView *)editBackView{
    if (!_editBackView) {
        _editBackView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/6.f)];
    }
    return _editBackView;
}


-(void)layoutSubviews{
    CGFloat padding = 50.f;
    CGFloat btnW = (CGRectGetWidth(self.editBackView.frame) - padding*(self.btnMutArr.count+1))/self.btnMutArr.count;
    CGFloat btnH = btnW;
    
    for (int i = 0; i< self.btnMutArr.count; i++) {
        UIButton *tempBtn = self.btnMutArr[i];
        [tempBtn setFrame:CGRectMake(padding+i*(padding+btnW), (CGRectGetHeight(self.editBackView.frame)-btnH)/2.f, btnW, btnH)];
        tempBtn.layer.cornerRadius = btnW/2.f;
        tempBtn.layer.masksToBounds = YES;
    }
}

-(void)p_addBtn{
    CGFloat btnCount = 3;
    CGFloat padding = 50.f;
    CGFloat btnW = (CGRectGetWidth(self.editBackView.frame) - padding*(btnCount+1))/btnCount;
    CGFloat btnH = btnW;
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(p_clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setFrame:CGRectMake(padding+i*(padding+btnW), (CGRectGetHeight(self.editBackView.frame)-btnH)/2.f, btnW, btnH)];
        button.layer.cornerRadius = btnW/2.f;
        button.layer.masksToBounds = YES;
        
        
        
        switch (i) {
            case 0:{
                button.tag = quitShareAndEditViewOption;
                [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
            }
                break;
            case 1:{
                button.tag = EditPhotoOption;
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
        [self.editBackView addSubview:button];
    }
}



-(void)p_clickButton:(UIButton *)sender{
    
    switch (sender.tag) {
        case quitShareAndEditViewOption:{//返回
            [self dismissShareAndEditView];
        }
            break;
        case EditPhotoOption:{//画板面板弹出
            self.backImageView.userInteractionEnabled = NO;
            DrawBoardViewController *drawBoardVC = [[DrawBoardViewController alloc] initWithImage:self.shareImg];
            drawBoardVC.drawBoardDelegate = self;
            [self presentViewController:drawBoardVC animated:NO completion:nil];
        }
            break;
        case SharePhotoOption:{//分享
            BNCUMShare *shareView = [BNCUMShare shareWithUMShare];
            [shareView shareImg:self.shareImg];
        }
            break;
    }
}


-(void)showShareAndEditView{
    if (self.editBackView.y < [[UIScreen mainScreen] bounds].size.height) {
        return;
    }
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:duration animations:^{
        tempSelf.editBackView.y = ([[UIScreen mainScreen] bounds].size.height/6.f)*5;
    }];
}

-(void)dismissShareAndEditView{
    if (self.editBackView.y>=[[UIScreen mainScreen] bounds].size.height) {
        return;
    }
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:duration animations:^{
        tempSelf.editBackView.y = [[UIScreen mainScreen] bounds].size.height;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - DrawBoardViewControllerDelegaete
-(void)cancelEdit{
    self.backImageView.userInteractionEnabled = YES;
    [self showShareAndEditView];
}

-(void)finishEditWithImage:(UIImage *)finishImage{
    self.backImageView.userInteractionEnabled = YES;
    self.shareImg = finishImage;
    [self.backImageView setImage:self.shareImg];
    
    [self showShareAndEditView];
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.image = self.shareImg;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

@end
