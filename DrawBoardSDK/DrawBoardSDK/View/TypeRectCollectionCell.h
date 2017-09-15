//
//  TypeRectCollectionCell.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/6.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellDelegate.h"


@interface TypeRectCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id<CollectionCellDelegate> rectTypeDelegate;

@property (nonatomic, assign) RectTypeOptions defaultRectType;

@end

