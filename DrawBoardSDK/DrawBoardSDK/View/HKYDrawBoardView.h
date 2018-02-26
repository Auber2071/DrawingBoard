//
//  HKYDrawBoardView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HKYEditView.h"
#import "HKYTextModel.h"


typedef NS_ENUM(NSInteger,DrawingStatus){
    DrawingStatusBegin,//准备绘制
    DrawingStatusMove,//正在绘制
    DrawingStatusEnd//结束绘制
};

@class HKYTextModel;
@class HKYDrawBoardView;
@protocol HKYDrawBoardViewDeletage <NSObject>
///绘图面板  编辑已绘制的文字回调
- (void)drawBoard:(HKYDrawBoardView *)drawView drawBoardBtnClickWithTag:(NSInteger)tag;

///绘图面板  绘图状态回调
- (void)drawBoard:(HKYDrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus;

@end

@interface HKYDrawBoardView : UIView

@property (nonatomic, assign) id<HKYDrawBoardViewDeletage> delegate;
@property (nonatomic, assign) EditMenuTypeOptions editTypeOption;
@property (nonatomic, assign) CGFloat lineWidth;//当前线条宽度
@property (nonatomic, strong) UIColor *lineColor;//当前线条颜色
@property (nonatomic, assign) RectTypeOptions rectTypeOption;

-(void)setupLabelWithTextModel:(HKYTextModel *)textModel;




@end
