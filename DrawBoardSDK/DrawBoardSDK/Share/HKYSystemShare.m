//
//  HKYSystemShare.m
//  HKYShareKit
//
//  Created by kai han on 2018/1/31.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import "HKYSystemShare.h"
@interface HKYSystemShare()
@property (nonatomic, assign) BOOL isOpenLog;
@property (nonatomic, strong) UIViewController *viewController;

@end


@implementation HKYSystemShare
- (void)openLog:(BOOL)logOnOff{
    self.isOpenLog = logOnOff;
}

- (void)debugLogWithString:(NSString *)string{
    if (self.isOpenLog) {
        NSLog(@"%@",string);
    }
}

-(void)shareWithSourceController:(UIViewController *)viewController Items:(NSArray *)array{
    self.viewController = viewController;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    
    __weak typeof(activityVC) tempActivityVC = activityVC;
    __weak typeof(self) tempSelf = self;

    //判断系统版本,初始化点击回调方法
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        [self debugLogWithString:[NSString stringWithFormat:@"activityType :%@", activityType]];
            if (completed){//完成
                [tempSelf debugLogWithString:@"completed"];
            }else{//取消
                [tempSelf debugLogWithString:@"cancel"];
            }
            if (activityError) {
                [tempActivityVC dismissViewControllerAnimated:YES completion:nil];
            }
        };
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.viewController.navigationController presentViewController:activityVC animated:YES completion:nil];
        }else {
            // Change Rect to position Popover
            UIBarButtonItem *shareBarButtonItem = self.viewController.navigationItem.rightBarButtonItem;
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
            [popup presentPopoverFromBarButtonItem:shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    });
}

@end
