//
//  CollectionCellDelegate.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/27.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionCellDelegate <NSObject>

@optional

-(void)changeLineWidth:(CGFloat)lineWidth;

-(void)changeRectTypeOption:(RectTypeOptions)rectTypeOption;

@end

