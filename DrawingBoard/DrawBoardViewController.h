//
//  DrawBoardViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/4.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawBoardViewController;
@protocol DrawBoardViewControllerDelegaete <NSObject>

-(void)cancelEdit;
-(void)finishEditWithImage:(UIImage *)finishImage;

@end

@interface DrawBoardViewController : UIViewController

-(instancetype)initWithImage:(UIImage *)backImage;
@property (nonatomic, assign) id<DrawBoardViewControllerDelegaete> drawBoardDelegate;

@end
