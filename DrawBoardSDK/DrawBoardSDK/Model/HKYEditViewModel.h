//
//  HKYEditViewModel.h
//  HKYShareKit
//
//  Created by hankai on 2018/1/11.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKYEditViewModel : NSObject
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemNormalImgName;
@property (nonatomic, strong) NSString *itemSelectedImgName;
@property (nonatomic, strong) NSString *itemHighLightImgName;

@property (nonatomic, assign) NSInteger itemTag;

@end
