//
//  BNCUMShare.m
//  PrimaryLevel_JX
//
//  Created by hankai on 2017/6/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "BNCUMShare.h"
#import <UMSocialCore/UMSocialCore.h>

@interface BNCUMShare ()<UMSocialShareMenuViewDelegate>
@property (nonatomic, strong) UMSocialShareUIConfig *shareUIConfig;

@end

@implementation BNCUMShare
+ (BNCUMShare *) shareWithUMShare{
    static BNCUMShare *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc]init];
    });
    return shareObject;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        [self designShareView];
    }
    return self;
}
-(void)setPlatTypeOrder:(NSArray *)platTypeOrder{
    _platTypeOrder = platTypeOrder;
    [UMSocialUIManager setPreDefinePlatforms:_platTypeOrder];//平台排序
}

-(void)desingPlatformFileteds:(NSArray *)platTypes platformIcons:(NSArray *)platformIcons platformNames:(NSArray *)platformNames{
    for (int i = 0; i< platTypes.count; i++) {
        UMSocialPlatformType platform = (UMSocialPlatformType)[platTypes[i] integerValue];
        NSString *iconName = platformIcons[i];
        NSString *platformname = platformNames[i];
        if (iconName.length<=0||platformname.length<=0) continue;
        [UMSocialUIManager addCustomPlatformWithoutFilted:platform withPlatformIcon:[UIImage imageNamed:iconName] withPlatformName:platformname];
    }
}

-(void)designTitleColor:(UIColor *)titleColor WithPlatformNameColor:(UIColor *)platformNameColor{
    _shareUIConfig.shareTitleViewConfig.shareTitleViewTitleColor = titleColor;
    _shareUIConfig.sharePlatformItemViewConfig.sharePlatformItemViewPlatformNameColor = platformNameColor;
}

- (void)designShareView{
    [UMSocialUIManager setShareMenuViewDelegate:self];
    //显示分享面板
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_QQ withPlatformIcon:[UIImage imageNamed:@"icon-qq"] withPlatformName:@"QQ"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine withPlatformIcon:[UIImage imageNamed:@"icon-pyq"] withPlatformName:@"朋友圈"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Qzone withPlatformIcon:[UIImage imageNamed:@"icon-qq-kj"] withPlatformName:@"QQ空间"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Sina withPlatformIcon:[UIImage imageNamed:@"icon-wb"] withPlatformName:@"微博"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatFavorite withPlatformIcon:[UIImage imageNamed:@"icon-wxsc"] withPlatformName:@"微信收藏"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession withPlatformIcon:[UIImage imageNamed:@"icon-wx"] withPlatformName:@"微信"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Sms withPlatformIcon:[UIImage imageNamed:@"icon-dx"] withPlatformName:@"短信"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Email withPlatformIcon:[UIImage imageNamed:@"icon-yx"] withPlatformName:@"邮箱"];
    
    
    //分享平台默认顺序
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_Sms),@(UMSocialPlatformType_Email)]];//平台排序
    
    
    //面板位置
    UMSocialShareUIConfig *shareUIConfig = [UMSocialShareUIConfig shareInstance];
    _shareUIConfig = shareUIConfig;
    shareUIConfig.shareTitleViewConfig.shareTitleViewTitleString = @"分享到";
    shareUIConfig.shareTitleViewConfig.shareTitleViewTitleColor = UIColorFromRGB(0xf17f5c);
    shareUIConfig.shareTitleViewConfig.shareTitleViewFont = [UIFont systemFontOfSize:14];
    shareUIConfig.shareTitleViewConfig.shareTitleViewBackgroundColor = [UIColor clearColor];
    
    shareUIConfig.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    switch (self.viewPostion) {
        case PositionType_Bottom:
            shareUIConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
            break;
        case PositionType_Middle:
            shareUIConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Middle;

            break;
        default:
            shareUIConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
            break;
    }
    if (shareUIConfig.sharePageGroupViewConfig.sharePageGroupViewPostionType == UMSocialSharePageGroupViewPositionType_Middle) {
        shareUIConfig.sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndMid = 3.f;
        shareUIConfig.shareContainerConfig.shareContainerCornerRadius = 8.f;
    }
    
    shareUIConfig.sharePlatformItemViewConfig.sharePlatformItemViewPlatformNameColor = UIColorFromRGB(0xf17f5c);
    
    shareUIConfig.shareCancelControlConfig.shareCancelControlText = @"取消";
    shareUIConfig.shareCancelControlConfig.shareCancelControlTextFont = [UIFont systemFontOfSize:16];
    shareUIConfig.shareCancelControlConfig.shareCancelControlBackgroundColor = UIColorFromRGB(0xffffff);
}

//分享事件
- (void)shareImg {
    //显示分享面板
    __weak typeof(self) tempSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [tempSelf shareImageToPlatformType:platformType];
    }];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    //shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    
    [shareObject setShareImage:self.screenCapture];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.bncShareDelegate completion:^(id data, NSError *error) {
        if (error) {
            DLog(@"************Share fail with error :  %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                DLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                DLog(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                DLog(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}


- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            DLog(@"error message:%@",result);
            
            switch (error.code) {
                case UMSocialPlatformErrorType_Unknow:
                    result = @"未知错误";
                    break;
                case UMSocialPlatformErrorType_NotSupport:
                    result = @"不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持）";
                    break;
                case UMSocialPlatformErrorType_AuthorizeFailed:
                    result = @"授权失败";
                    break;
                case UMSocialPlatformErrorType_ShareFailed:
                    result = @"分享失败";
                    break;
                case UMSocialPlatformErrorType_RequestForUserProfileFailed:
                    result = @"请求用户信息失败";
                    break;
                case UMSocialPlatformErrorType_ShareDataNil:
                    result = @"分享内容为空";
                    break;
                case UMSocialPlatformErrorType_ShareDataTypeIllegal:
                    result = @"分享内容不支持";
                    break;
                case UMSocialPlatformErrorType_CheckUrlSchemaFail:
                    result = @"schema URL fail";
                    break;
                case UMSocialPlatformErrorType_NotInstall:
                    result = @"应用未安装";
                    break;
                case UMSocialPlatformErrorType_Cancel:
                    result = @"用户取消操作";
                    break;
                case UMSocialPlatformErrorType_NotNetWork:
                    result = @"网络异常";
                    break;
                case UMSocialPlatformErrorType_SourceError:
                    result = @"第三方错误";
                    break;
                case UMSocialPlatformErrorType_ProtocolNotOverride:
                    result = @"对应的    UMSocialPlatformProvider的方法没有实现";
                    break;
                case UMSocialPlatformErrorType_NotUsingHttps:
                    result = @"没有用https的请求,@see UMSocialGlobal isUsingHttpsWhenShareContent";
                    break;
                    
                default:
                    result = @"邮件已存储到草稿箱";//error.code=1
                    break;
            }
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear {
    if (self.bncShareDelegate && [self.bncShareDelegate respondsToSelector:@selector(BNCUMSocialShareMenuViewDidAppear)]) {
        [self.bncShareDelegate BNCUMSocialShareMenuViewDidAppear];
    }
    DLog(@"UMSocialShareMenuViewDidAppear");
}

- (void)UMSocialShareMenuViewDidDisappear {
    if (self.bncShareDelegate && [self.bncShareDelegate respondsToSelector:@selector(BNCUMSocialShareMenuViewDidDisappear)]) {
        [self.bncShareDelegate BNCUMSocialShareMenuViewDidDisappear];
    }
    DLog(@"UMSocialShareMenuViewDidDisappear");
}

-(UIView *)UMSocialParentView:(UIView *)defaultSuperView{
    if (self.bncShareDelegate && [self.bncShareDelegate respondsToSelector:@selector(BNCUMSocialParentView:)]) {
        UIView *tempView = [self.bncShareDelegate BNCUMSocialParentView:defaultSuperView];
        return tempView;
    }
    return defaultSuperView;
}


/**
 截屏
 */
-(UIImage *)screenCapture{
    if (!_screenCapture) {
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
        
        _screenCapture = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _screenCapture;
}


@end
