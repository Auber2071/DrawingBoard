//
//  ShareAndEditPhotoViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareAndEditPhotoViewControllerDelegate <NSObject>

-(void)shareBtnClick;

@end

@interface ShareAndEditPhotoViewController : UIViewController

@property (nonatomic, assign) id<ShareAndEditPhotoViewControllerDelegate> delegate;

//分享的图片
@property (nonatomic, strong) UIImage *shareImg;

- (instancetype)initWithImage:(UIImage *)image;

@end
