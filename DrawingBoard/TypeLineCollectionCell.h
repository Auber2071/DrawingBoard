//
//  TypeLineCollectionCell.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/26.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellDelegate.h"

@interface TypeLineCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id<CollectionCellDelegate> typeLineDelegate;

@end
