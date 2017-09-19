//
//  HKYTypeLineCollectionCell.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/26.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKYCollectionCellDelegate.h"

@interface HKYTypeLineCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id<HKYCollectionCellDelegate> typeLineDelegate;

@property (nonatomic, assign) NSUInteger defaultLineWidth;

@end
