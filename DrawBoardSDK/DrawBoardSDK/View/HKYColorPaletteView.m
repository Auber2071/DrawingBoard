//
//  HKYColorPaletteView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/24.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYColorPaletteView.h"
#import "HKYTypeLineCollectionCell.h"


static NSString *CellLineIdentifierCell = @"CellLineIdentifierCell";
static NSString *CellRectIdentifierCell = @"CellRectIdentifierCell";

@interface HKYColorPaletteView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HKYCollectionCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIScrollView *colorBackGroundView;
@property (nonatomic, strong) NSArray *colorArr;

@property (nonatomic, strong) NSMutableArray *btnMutArr;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, assign) UIEdgeInsets buttonInset;
@property (nonatomic, assign) CGFloat normalWidth;
@property (nonatomic, assign) CGFloat largeWidth;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) NSInteger defaultColorIndex;

@property (nonatomic, assign) RectTypeOptions selectedRectType;
@property (nonatomic, assign) NSUInteger lineWidth;
@property (nonatomic, assign) NSUInteger rectLineW;



@property (nonatomic, strong) HKYColorPaletteViewModel *colorPaletteViewModel;

@end

@implementation HKYColorPaletteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBP(0xffffff, 0.6);
        [self addSubview:self.colorBackGroundView];
        [self addSubview:self.collectionView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.colorBackGroundView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*0.5)];
    [self.collectionView setFrame:CGRectMake(0, CGRectGetMaxY(self.colorBackGroundView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(self.colorBackGroundView.frame))];
    
    self.buttonInset = UIEdgeInsetsMake(0, SCREEN_WIDTH*0.074, 0, SCREEN_WIDTH*0.074);
    self.normalWidth = 18;
    self.largeWidth = 26;
    self.padding = (SCREEN_WIDTH - self.buttonInset.left - self.buttonInset.right - self.normalWidth*self.colorArr.count)/(self.colorArr.count-1);
    for (int i = 0; i<self.btnMutArr.count; i++) {
        UIButton *button = self.btnMutArr[i];
        [button setBounds:CGRectMake(0, 0, self.normalWidth, self.normalWidth)];
        button.center = CGPointMake(self.buttonInset.left+self.normalWidth/2.f +i*(self.normalWidth+self.padding), CGRectGetHeight(self.colorBackGroundView.frame)/2.f);
        button.layer.cornerRadius = button.size.width/2.f;
        
        if (self.defaultColorIndex == i) {
            self.selectedColor = self.colorArr[i];
            self.lastBtn = button;
            [self p_reserBtnFrameWithButton:button isLast:NO tag:(NSUInteger)i];
        }
    }
}

- (void)setupColorPaletteViewDataSource:(HKYColorPaletteViewModel *)colorPaletteViewModel{
    _colorPaletteViewModel = colorPaletteViewModel;
    self.colorArr = colorPaletteViewModel.colorArr;
    self.selectedRectType = colorPaletteViewModel.defaultTypeOption;
    self.lineWidth = colorPaletteViewModel.lineW;
    self.defaultColorIndex = colorPaletteViewModel.defaultColorIndex;
    self.rectLineW = colorPaletteViewModel.rectLineW;
    if (self.defaultColorIndex<self.colorArr.count) {
        self.selectedColor = self.colorArr[colorPaletteViewModel.defaultColorIndex];
    }else{
        NSLog(@"error:defaultColorIndex>colorArr.count");
    }
    self.page = 0;
    [self.collectionView reloadData];
    [self p_addColorOptions];
}

#pragma mark - CollectionCellDelegate

-(void)changeLineWidth:(CGFloat)lineWidth{
    self.lineWidth = lineWidth;
    if (self.colorPaletteViewDelegate && [self.colorPaletteViewDelegate respondsToSelector:@selector(colorPaletteViewWithColor:rectTypeOption:lineWidth:)]) {
        [self.colorPaletteViewDelegate colorPaletteViewWithColor:self.selectedColor rectTypeOption:self.selectedRectType lineWidth:lineWidth];
    }
}

-(void)changeRectTypeOption:(RectTypeOptions)rectTypeOption{
    self.selectedRectType = rectTypeOption;
    if (self.colorPaletteViewDelegate && [self.colorPaletteViewDelegate respondsToSelector:@selector(colorPaletteViewWithColor:rectTypeOption:lineWidth:)]) {
        [self.colorPaletteViewDelegate colorPaletteViewWithColor:self.selectedColor rectTypeOption:rectTypeOption lineWidth:_rectLineW];
    }
}



#pragma mark - Private Methods

- (void)scrollToPage:(NSUInteger)page{
    self.page = page;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(void)p_addColorOptions{
    for (int i = 0; i<self.colorArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:self.colorArr[i]];
        button.tag = (NSInteger)i;
        [button addTarget:self action:@selector(p_clickColorOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorBackGroundView addSubview:button];
        [self.btnMutArr addObject:button];
    }
}


-(void)p_clickColorOption:(UIButton *)sender{
    if (self.lastBtn == sender) {
        return;
    }
    [self p_reserBtnFrameWithButton:sender isLast:NO tag:sender.tag];
    [self p_reserBtnFrameWithButton:self.lastBtn isLast:YES tag:self.lastBtn.tag];
    self.lastBtn = sender;
    
    _selectedColor = self.colorArr[sender.tag];
    if (self.colorPaletteViewDelegate && [self.colorPaletteViewDelegate respondsToSelector:@selector(colorPaletteViewWithColor:rectTypeOption:lineWidth:)]) {
        [self.colorPaletteViewDelegate colorPaletteViewWithColor:_selectedColor rectTypeOption:self.selectedRectType lineWidth:(self.page == 0 ? self.lineWidth:_rectLineW)];
    }
}

-(void)p_reserBtnFrameWithButton:(UIButton *)sender isLast:(BOOL)isLast tag:(NSInteger)tag{
    if (isLast) {
        sender.size = CGSizeMake(self.normalWidth, self.normalWidth);
    }else{
        sender.size = CGSizeMake(self.largeWidth, self.largeWidth);
    }
    sender.layer.cornerRadius = sender.size.width/2.f;
    sender.center = CGPointMake(self.buttonInset.left+self.normalWidth/2.f +tag*(self.normalWidth+self.padding), CGRectGetHeight(self.colorBackGroundView.frame)/2.f);
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.item) {
        case 0:{
            HKYTypeLineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellLineIdentifierCell forIndexPath:indexPath];
            cell.typeLineDelegate = self;
            cell.defaultLineWidth = self.lineWidth;
            return cell;
        }
            break;
        case 1:{
            HKYTypeRectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellRectIdentifierCell forIndexPath:indexPath];
            cell.rectTypeDelegate = self;
            [cell setDataSource:self.colorPaletteViewModel.shapesArr defaultRectType:self.selectedRectType];
            return cell;
        }
            break;
    }
    UICollectionViewCell *cell = nil;
    return cell;
}


#pragma mark - Get Methods

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *viewLayout = [[UICollectionViewFlowLayout alloc]init];
        viewLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(self.colorBackGroundView.frame));
        viewLayout.minimumLineSpacing = 0.f;
        viewLayout.minimumInteritemSpacing = 0.f;
        viewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colorBackGroundView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(self.colorBackGroundView.frame)) collectionViewLayout:viewLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[HKYTypeLineCollectionCell class] forCellWithReuseIdentifier:CellLineIdentifierCell];
        [_collectionView registerClass:[HKYTypeRectCollectionCell class] forCellWithReuseIdentifier:CellRectIdentifierCell];
    }
    return _collectionView;
}


-(UIScrollView *)colorBackGroundView{
    if (!_colorBackGroundView) {
        _colorBackGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*0.5)];
        _colorBackGroundView.showsHorizontalScrollIndicator = NO;
        _colorBackGroundView.backgroundColor = [UIColor clearColor];
    }
    return _colorBackGroundView;
}

-(NSMutableArray *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = [NSMutableArray array];
    }
    return _btnMutArr;
}
@end
