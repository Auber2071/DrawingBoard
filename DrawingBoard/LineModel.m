//
//  LineModel.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/25.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "LineModel.h"

@interface LineModel ()

@property (nonatomic, strong, readwrite) UIColor *lineColor;
@property (nonatomic, assign, readwrite) CGFloat lineWidth;
@property (nonatomic, strong, readwrite) NSMutableArray<NSValue *> *lineTrackMutArr;
@property (nonatomic, assign, readwrite) EditMenuTypeOptions lineType;
@property (nonatomic, assign, readwrite) RectTypeOptions rectType;

@end

@implementation LineModel

- (instancetype)initWithLineTrack:(NSMutableArray<NSValue *> *)lineTrack lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth lineType:(EditMenuTypeOptions)lineType rectType:(RectTypeOptions)rectType{
    
    self = [super init];
    if (self) {
        _lineColor = lineColor;
        _lineWidth = lineWidth;
        _lineTrackMutArr = lineTrack;
        _lineType = lineType;
        _rectType = rectType;
    }
    return self;
}

@end
