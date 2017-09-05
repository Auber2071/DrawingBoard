//
//  ShareAndEditPhotoView.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/1.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareAndEditPhotoView;
@protocol shareAndEditPhotoViewDelegate <NSObject>
-(void)back;
-(void)EditPhoto;
-(void)shareImage;
@end

@interface ShareAndEditPhotoView : UIView
@property (nonatomic, assign) id<shareAndEditPhotoViewDelegate> shareAndEditDelegate;

-(void)showShareAndEditView;
-(void)dismissShareAndEditView;

@end
