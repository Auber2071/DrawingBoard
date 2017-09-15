//
//  ColorPaletteView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/24.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeRectCollectionCell.h"


@class ColorPaletteView;
@protocol ColorPaletteViewDelegate <NSObject>

- (void)colorPaletteViewWithColor:(UIColor *)color rectTypeOption:(RectTypeOptions)rectTypeOption lineWidth:(NSUInteger)lineWidth;


@end

@interface ColorPaletteView : UIView

@property (nonatomic, assign) id<ColorPaletteViewDelegate> colorPaletteViewDelegate;
- (instancetype)initWithFrame:(CGRect)frame ColorArr:(NSArray *)colorArr defaultColorIndex:(NSInteger)defaultColorIndex defaultLineWidth:(NSUInteger)defaultLineWidth defaultRectTypeOption:(RectTypeOptions)defaultTypeOption defaultRectWidth:(NSUInteger)defaultRectWidth;


- (void)scrollToPage:(NSUInteger)page;

@end
