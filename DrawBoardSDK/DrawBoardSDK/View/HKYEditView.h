//
//  HKYEditView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKYEditViewModel.h"

typedef NS_ENUM(NSInteger,EditMenuTypeOptions) {
    EditMenuTypeOptionNone,
    EditMenuTypeOptionCharacter,
    EditMenuTypeOptionLine,
    EditMenuTypeOptionRect,
    EditMenuTypeOptionEraser,
    EditMenuTypeOptionBack
};

@class HKYEditView;

@protocol HKYEditViewDelegate <NSObject>

///批注选项     切换批注选项回调
-(void)HKYEditView:(HKYEditView *)sender changedDrawingOption:(EditMenuTypeOptions)drawingOption;


@end

@interface HKYEditView : UIView

@property (nonatomic, assign) id<HKYEditViewDelegate> editViewDelegate;
@property (nonatomic, strong) NSArray <HKYEditViewModel*>*dataSource;

@end
