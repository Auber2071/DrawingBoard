//
//  HKYColorPaletteView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/24.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKYTypeRectCollectionCell.h"
#import "HKYColorPaletteViewModel.h"


@class HKYColorPaletteView;
@protocol HKYColorPaletteViewDelegate <NSObject>

- (void)colorPaletteViewWithColor:(UIColor *)color rectTypeOption:(RectTypeOptions)rectTypeOption lineWidth:(NSUInteger)lineWidth;

@end

@interface HKYColorPaletteView : UIView

@property (nonatomic, assign) id<HKYColorPaletteViewDelegate> colorPaletteViewDelegate;

- (void)scrollToPage:(NSUInteger)page;
- (void)setupColorPaletteViewDataSource:(HKYColorPaletteViewModel *)colorPaletteViewModel;

@end
