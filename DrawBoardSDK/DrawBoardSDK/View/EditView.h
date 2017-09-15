//
//  EditView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,EditMenuTypeOptions) {
    EditMenuTypeOptionCharacter,
    EditMenuTypeOptionLine,
    EditMenuTypeOptionRect,
    EditMenuTypeOptionEraser,
    EditMenuTypeOptionBack
};

@class EditView;

@protocol EditViewDelegate <NSObject>
-(void)EditView:(EditView *)sender changedDrawingOption:(EditMenuTypeOptions)drawingOption;


@end

@interface EditView : UIView
@property (nonatomic, assign) id<EditViewDelegate> editViewDelegate;


@end
