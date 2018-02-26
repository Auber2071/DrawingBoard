//
//  HKYSystemShare.h
//  HKYShareKit
//
//  Created by kai han on 2018/1/31.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKYSystemShare : NSObject


/**
 分享事件

 @param viewController 源控制器
 @param array 分享item
 */
-(void)shareWithSourceController:(UIViewController *)viewController Items:(NSArray *)array;
/**
 是否开启起日志
 */
- (void)openLog:(BOOL)logOnOff;
@end
