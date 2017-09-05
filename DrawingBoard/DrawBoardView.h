//
//  DrawBoardView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EditView.h"

typedef NS_ENUM(NSInteger,DrawingStatus){
    DrawingStatusBegin,//准备绘制
    DrawingStatusMove,//正在绘制
    DrawingStatusEnd//结束绘制
};


@class DrawBoardView;
@protocol DrawBoardViewDeletage <NSObject>

- (void)drawBoard:(DrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus;

@end

@interface DrawBoardView : UIView

@property (nonatomic, assign) id<DrawBoardViewDeletage> delegate;
@property (nonatomic, assign) EditMenuTypeOptions drawOption;
@property (nonatomic, assign) CGFloat lineWidth;//当前线条宽度
@property (nonatomic, strong) UIColor *lineColor;//当前线条颜色


-(void)addLabelWithText:(NSString *)text textColor:(UIColor *)textColor;
@end
