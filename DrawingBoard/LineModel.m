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
@property (nonatomic, assign, readwrite) EditMenuType lineType;

@end

@implementation LineModel

- (instancetype)initWithLineTrack:(NSMutableArray<NSValue *> *)lineTrack lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth lineType:(EditMenuType)lineType {
    
    self = [super init];
    if (self) {
        _lineColor = lineColor;
        _lineWidth = lineWidth;
        _lineTrackMutArr = lineTrack;
        _lineType = lineType;
    }
    return self;
}

@end
