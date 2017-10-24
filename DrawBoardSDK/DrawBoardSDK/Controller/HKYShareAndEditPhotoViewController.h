//
//  HKYShareAndEditPhotoViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/7.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKYShareAndEditPhotoViewControllerDelegate <NSObject>

-(void)shareBtnClick;

@end

@interface HKYShareAndEditPhotoViewController : UIViewController

@property (nonatomic, assign) id<HKYShareAndEditPhotoViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;

@end
