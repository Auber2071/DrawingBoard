//
//  HKYShareAndEditPhotoViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HKYSharePlatformType)
{
    HKYSystemPlatformShare,
    HKYUMSocialPlatformShare
};

@protocol HKYShareAndEditPhotoViewControllerDelegate <NSObject>
@optional
///分享按钮
-(void)shareBtnClick;

@end


@interface HKYShareAndEditPhotoViewController : UIViewController

///源控制器
@property (nonatomic, strong) UIViewController *viewController;

///分享平台 默认为系统分享
@property (nonatomic, assign) HKYSharePlatformType sharePlatformType;

///批注完成后的图片
@property (nonatomic, strong, readonly) UIImage *shareImage;

///代理
@property (nonatomic, assign) id<HKYShareAndEditPhotoViewControllerDelegate> delegate;

///初始化方法   必须模态推出
- (instancetype)initWithImage:(UIImage *)image;

///是否打开日志   默认关闭
- (void)openLog:(BOOL)logOnOff;
@end
