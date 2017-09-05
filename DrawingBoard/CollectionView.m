//
//  CollectionView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/24.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "CollectionView.h"
#import "TypeLineCollectionCell.h"

NSString * const EditMenuLineColorChangeNotification = @"EditMenuLineColorChangeNotification";
NSString * const EditMenuLineWidthChangeNotification = @"EditMenuLineWidthChangeNotification";


static NSString *CellLineIdentifierCell = @"CellLineIdentifierCell";
static NSString *CellCharacterIdentifierCell = @"CellCharacterIdentifierCell";
static NSString *CellGraphIdentifierCell = @"CellGraphIdentifierCell";

@interface CollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CollectionCellDelegate>


@end

@implementation CollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *viewLayout = [[UICollectionViewFlowLayout alloc]init];
        viewLayout.itemSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame));
        viewLayout.minimumLineSpacing = 0.f;
        viewLayout.minimumInteritemSpacing = 0.f;
        viewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:viewLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[TypeLineCollectionCell class] forCellWithReuseIdentifier:CellLineIdentifierCell];

        [self addSubview:collectionView];
    }
    return self;
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    
    switch (indexPath.item) {
        case 0:{
            TypeLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellLineIdentifierCell forIndexPath:indexPath];
            cell.typeLineDelegate = self;
            return cell;
        }
            break;
    }
    UICollectionViewCell *cell = nil;
    return cell;
}


#pragma mark - CollectionCellDelegate
-(void)changeLineColor:(UIColor *)lineColor{
    [[NSNotificationCenter defaultCenter] postNotificationName:EditMenuLineColorChangeNotification object:nil userInfo:[NSDictionary dictionaryWithObject:lineColor forKey:@"lineColor"]];
    
}
-(void)changeLineWidth:(CGFloat)lineWidth{
    [[NSNotificationCenter defaultCenter] postNotificationName:EditMenuLineWidthChangeNotification object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:lineWidth] forKey:@"lineWidth"]];

}

@end
