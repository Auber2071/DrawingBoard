//
//  HKYLineModel.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/25.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYLineModel.h"

@interface HKYLineModel ()

@property (nonatomic, strong, readwrite) UIColor *lineColor;
@property (nonatomic, assign, readwrite) CGFloat lineWidth;
@property (nonatomic, assign, readwrite) EditMenuTypeOptions editType;
@property (nonatomic, assign, readwrite) RectTypeOptions rectType;

@end

@implementation HKYLineModel

- (instancetype)initWithLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth editType:(EditMenuTypeOptions)editType rectType:(RectTypeOptions)rectType{
    
    self = [super init];
    if (self) {
        _lineColor = lineColor;
        _lineWidth = lineWidth;
        _editType = editType;
        _rectType = rectType;
    }
    return self;
}

@end
