//
//  AppDelegate.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import <UMSocialCore/UMSocialCore.h>
#define USHARE_APPKEY @"592395994544cb50e20019e1"//友盟appKey


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureUMengSocialData];
    
    ViewController *VC = [[ViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - UShare
//初始化友盟相关配置
-(void)configureUMengSocialData{
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#else
    [[UMSocialManager defaultManager] openLog:NO];
#endif
    
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    [self configUSharePlatforms];
    [self confitUShareSettings];
}


- (void)confitUShareSettings {
    [UMSocialGlobal shareInstance].isUsingWaterMark = NO;
    //配置水印
    //创建UMSocialImageWarterMarkConfig
    UMSocialImageWarterMarkConfig* imageWarterMarkConfig = [[UMSocialImageWarterMarkConfig alloc] init];
    //配置imageWarterMarkConfig的参数
    imageWarterMarkConfig.warterMarkImage = [UIImage imageNamed:@"liantong"];
    //创建UMSocialWarterMarkConfig
    UMSocialWarterMarkConfig* warterMarkConfig = [[UMSocialWarterMarkConfig alloc] init];
    //配置warterMarkConfig的参数
    //...TODO
    //设置配置类
    [warterMarkConfig setUserDefinedImageWarterMarkConfig:imageWarterMarkConfig];
    
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx45bee633d52d515d" appSecret:@"40aa4e51054b1f6142f87942512f7f3d" redirectURL:@"http://www.bonc.com.cn"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106106351"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3729399173"  appSecret:@"372837d5b602106fd4894be1b3055fb5" redirectURL:@"http://www.bonc.com.cn"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
