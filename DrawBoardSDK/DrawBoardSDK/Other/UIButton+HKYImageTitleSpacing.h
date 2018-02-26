//
//  UIButton+HKYImageTitleSpacing.h
//  HKYShareKit
//
//  Created by hankai on 2018/1/11.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BNCButtonEdgeInsetsStyle) {
    BNCButtonEdgeInsetsStyleTop, // image在上，label在下
    BNCButtonEdgeInsetsStyleLeft, // image在左，label在右
    BNCButtonEdgeInsetsStyleBottom, // image在下，label在上
    BNCButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (HKYImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(BNCButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;

@end
