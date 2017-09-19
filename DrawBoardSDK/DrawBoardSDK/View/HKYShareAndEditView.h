//
//  HKYShareAndEditView.h
//  DrawBoardSDK
//
//  Created by hankai on 2017/9/19.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HKYShareAndEditView;

@protocol HKYShareAndEditViewDelegate <NSObject>
-(void)cancleAction;
-(void)editAction;
-(void)shareAction;

@end

@interface HKYShareAndEditView : UIView
@property (nonatomic, assign) id<HKYShareAndEditViewDelegate> shareAndEditViewDelegate;

@end
