//
//  TypeLineCollectionCell.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/26.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TypeLineCollectionCell.h"

@interface TypeLineCollectionCell ()
@property (nonatomic, strong) NSMutableArray *colorMutArr;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UILabel *labelIndicator;

//@property (nonatomic, strong) UIButton *lastButton;

@end

@implementation TypeLineCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 4.f;
        self.lineColor = [UIColor redColor];
        [self p_addColorsBtns];
        [self p_lineWidth];
    }
    return self;
}

-(void)p_lineWidth{
    
    self.labelIndicator = [[UILabel alloc] init];
    self.labelIndicator.layer.masksToBounds = YES;
    [self.labelIndicator setFrame:CGRectMake(0, 0, self.lineWidth, self.lineWidth)];
    self.labelIndicator.center = CGPointMake(24, 24);
    self.labelIndicator.layer.cornerRadius = CGRectGetWidth(self.labelIndicator.frame)/2.f;
    self.labelIndicator.backgroundColor = self.lineColor;
    [self addSubview:self.labelIndicator];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(35, 10, 100, 30)];
    slider.minimumValue = 5.f;
    slider.maximumValue = 20.f;
    slider.value = self.lineWidth;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
}

-(void)sliderValueChanged:(UISlider *)slider{
    NSLog(@"New value=%f",slider.value);
    self.lineWidth = slider.value;
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:0 animations:^{
        CGRect tempFrame = tempSelf.labelIndicator.frame;
        tempFrame.size = CGSizeMake(slider.value, slider.value);
        tempSelf.labelIndicator.frame = tempFrame;
        tempSelf.labelIndicator.center = CGPointMake(24, 24);
        tempSelf.labelIndicator.layer.cornerRadius = CGRectGetWidth(tempSelf.labelIndicator.frame)/2.f;
    } completion:^(BOOL finished) {
        if (tempSelf.typeLineDelegate && [tempSelf.typeLineDelegate respondsToSelector:@selector(changeLineWidth:)]) {
            [tempSelf.typeLineDelegate changeLineWidth:tempSelf.lineWidth];
        }
    }];
}



-(void)p_addColorsBtns{
    UIEdgeInsets btnInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    CGFloat padding = 20.f;
    NSUInteger btnCount = self.colorMutArr.count;
    CGFloat btnW = (CGRectGetWidth(self.frame) - btnInsets.left - btnInsets.right - padding*(btnCount-1))/btnCount;
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(btnInsets.left + i*(btnW + padding),CGRectGetHeight(self.frame) - btnW - btnInsets.bottom, btnW, btnW)];
        [button setBackgroundColor:self.colorMutArr[i]];
        [button.layer setCornerRadius:CGRectGetWidth(button.frame)/2.f];
        [button.layer setBorderColor:[UIColor redColor].CGColor];
        [button.layer setBorderWidth:1.f];
        button.tag = (NSInteger)i;
        [button addTarget:self action:@selector(p_changeColor:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];

    }
}


-(void)p_changeColor:(UIButton *)sender{
//    if (![self.lastButton isEqual:sender]) {
//        sender.backgroundColor = [UIColor redColor];
//        self.lastButton.backgroundColor = [UIColor grayColor];
//        self.lastButton = sender;
//    }

    
    
    self.lineColor = self.colorMutArr[sender.tag];
    self.labelIndicator.backgroundColor = self.lineColor;
    if (self.typeLineDelegate && [self.typeLineDelegate respondsToSelector:@selector(changeLineColor:)]) {
        [self.typeLineDelegate changeLineColor:self.lineColor];
    }
}


-(NSMutableArray *)colorMutArr{
    if (!_colorMutArr) {
        _colorMutArr = [NSMutableArray array];
        [_colorMutArr addObject:[UIColor whiteColor]];
        [_colorMutArr addObject:[UIColor blackColor]];
        for (int i = 0; i<5; i++) {
            int R = (arc4random() % 256);
            int G = (arc4random() % 256);
            int B = (arc4random() % 256);
            UIColor *color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
            [_colorMutArr addObject:color];
        }
    }
    return _colorMutArr;
}

@end
