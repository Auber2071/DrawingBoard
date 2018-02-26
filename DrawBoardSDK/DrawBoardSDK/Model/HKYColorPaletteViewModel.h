//
//  HKYColorPaletteViewModel.h
//  HKYShareKit
//
//  Created by hankai on 2018/1/12.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKYShapeMode;



@interface HKYColorPaletteViewModel : NSObject

@property (nonatomic, strong) NSArray <UIColor*>*colorArr;
@property (nonatomic, assign) NSInteger defaultColorIndex;
@property (nonatomic, assign) NSInteger lineW;


@property (nonatomic, strong) NSArray <HKYShapeMode*>*shapesArr;
@property (nonatomic, assign) RectTypeOptions defaultTypeOption;
@property (nonatomic, assign) NSInteger rectLineW;


@end
