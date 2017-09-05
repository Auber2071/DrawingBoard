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
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *lineTrackMutArr;
@property (nonatomic, assign, readonly) EditMenuTypeOptions lineType;



- (instancetype)initWithLineTrack:(NSMutableArray<NSValue *> *)lineTrack lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth lineType:(EditMenuTypeOptions)lineType;

@end
