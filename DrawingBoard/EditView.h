//
//  EditView.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionView.h"

UIKIT_EXTERN NSString * const EditMenuTypeChangeNotification;


typedef NS_ENUM(NSInteger,EditMenuType) {
    EditMenuTypeLine,
    EditMenuTypeCharacter,
    EditMenuTypeRect,
    EditMenuTypeEraser,
    EditMenuTypeBack
};


@interface EditView : UIView


@end
