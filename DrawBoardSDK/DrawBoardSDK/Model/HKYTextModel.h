//
//  HKYTextModel.h
//  DrawBoardSDK
//
//  Created by hankai on 2017/9/19.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKYTextModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger textColorIndex;



@end
