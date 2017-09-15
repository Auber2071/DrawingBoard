//
//  LineModel.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/25.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"

@interface LineModel : NSObject

@property (nonatomic, strong, readonly) UIColor *lineColor;
@property (nonatomic, assign, readonly) CGFloat lineWidth;
@property (nonatomic, assign, readonly) EditMenuTypeOptions editType;
@property (nonatomic, assign, readonly) RectTypeOptions rectType;
@property (nonatomic, strong, readwrite) NSMutableArray<NSValue *> *lineTrackMutArr;



- (instancetype)initWithLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth editType:(EditMenuTypeOptions)editType rectType:(RectTypeOptions)rectType;

@end
