//
//  HKYDrawBoardViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/4.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKYDrawBoardViewController;
@protocol HKYDrawBoardViewControllerDelegaete <NSObject>

-(void)cancelEdit;
-(void)finishEditWithImage:(UIImage *)finishImage;

@end

@interface HKYDrawBoardViewController : UIViewController

-(instancetype)initWithImage:(UIImage *)backImage;
@property (nonatomic, assign) id<HKYDrawBoardViewControllerDelegaete> drawBoardDelegate;

@end
