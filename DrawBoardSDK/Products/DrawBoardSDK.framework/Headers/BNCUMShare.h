//
//  BNCUMShare.h
//  PrimaryLevel_JX
//
//  Created by hankai on 2017/6/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PositionType){
    PositionType_Bottom,//显示在底部
    PositionType_Middle,//显示在中间
};

@protocol BNCUMShareDelegate <NSObject>

@optional
/**
 *  分享面板显示的回调
 */
- (void)BNCUMSocialShareMenuViewDidAppear;

/**
 *  分享面板的消失的回调
 */
- (void)BNCUMSocialShareMenuViewDidDisappear;

/**
 *  返回分享面板的父窗口,用于嵌入在父窗口上显示
 *
 *  @param defaultSuperView 默认加载的父窗口
 *
 *  @return 返回实际的父窗口
 *  @note 返回的view应该是全屏的view，方便分享面板来布局。
 *  @note 如果用户要替换成自己的ParentView，需要保证该view能覆盖到navigationbar和statusbar
 *  @note 当前分享面板已经是在window上,如果需要切换就重写此协议，如果不需要改变父窗口则不需要重写此协议
 */
- (UIView*)BNCUMSocialParentView:(UIView*)defaultSuperView;

@end


@interface BNCUMShare : NSObject
+ (BNCUMShare *)shareWithUMShare;

/**
 * 分享平台包含sms,email时,此代理必须设置
 */
@property (nonatomic, assign) id<BNCUMShareDelegate> bncShareDelegate;

/**
 分享面板的位置，默认为bottom
 */
@property (nonatomic,assign)PositionType   viewPostion;


/**
 分享平台顺序
 默认为：微信、QQ、新浪微博、朋友圈、QQ空间、微信收藏、短信、邮箱
 */
@property (nonatomic, strong) NSArray *platTypeOrder;


/**
 字体颜色

 @param titleColor 标题颜色
 @param platformNameColor 平台名称颜色
 */
-(void)designTitleColor:(UIColor *)titleColor WithPlatformNameColor:(UIColor *)platformNameColor;


/**
 自定义平台icon及平台名称，类型与icon、名称顺序要一一对应

 @param platTypes 平台类型UMSocialPlatformType 枚举类型
 @param platformIcons 平台icon
 @param platformNames 平台名称
 */
-(void)desingPlatformFileteds:(NSArray *)platTypes platformIcons:(NSArray *)platformIcons platformNames:(NSArray *)platformNames;


/**
 分享事件

 @param image 需要分享的图片
 */
- (void)shareImg:(UIImage *)image;

@end
