//
//  HKYShapeMode.h
//  HKYShareKit
//
//  Created by hankai on 2018/1/12.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKYShapeMode : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIImage *normalImg;
@property (nonatomic, strong) UIImage *selectedImg;
@property (nonatomic, assign) NSInteger tag;


@end
