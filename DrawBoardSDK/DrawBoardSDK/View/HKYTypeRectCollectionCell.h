//
//  HKYTypeRectCollectionCell.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/6.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKYCollectionCellDelegate.h"


@interface HKYTypeRectCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id<HKYCollectionCellDelegate> rectTypeDelegate;

@property (nonatomic, assign) RectTypeOptions defaultRectType;

@end

