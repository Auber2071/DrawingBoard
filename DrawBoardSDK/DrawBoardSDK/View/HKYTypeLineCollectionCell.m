//
//  HKYTypeLineCollectionCell.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/26.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYTypeLineCollectionCell.h"

@interface HKYTypeLineCollectionCell ()
@property (nonatomic, strong) UISlider *slider;


@end

@implementation HKYTypeLineCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultLineWidth = 10.f;
        [self p_lineWidth:frame];
    }
    return self;
}

-(void)setDefaultLineWidth:(NSUInteger)defaultLineWidth{
    _defaultLineWidth = defaultLineWidth;
    self.slider.value = defaultLineWidth;
}

-(void)p_lineWidth:(CGRect)frame{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"画笔大小";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:12.f];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFrame:CGRectMake(10, 0, 60, CGRectGetHeight(frame))];
    [self addSubview:label];
    
    UIEdgeInsets sliderInset = UIEdgeInsetsMake(0, 10, 0, 10);
    CGFloat sliderX = CGRectGetMaxX(label.frame) + sliderInset.left;
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(sliderX, 0, CGRectGetWidth(frame) - sliderX - sliderInset.right, CGRectGetHeight(frame))];
    self.slider.minimumValue = 1.f;
    self.slider.maximumValue = 20.f;
    self.slider.value = self.defaultLineWidth;

    UIImage *image = [UIImage imageWithContentsOfFile:[HKYShareBundle pathForResource:@"icon_thumbImage_slider_colorPaletteView@3x" ofType:@"png" inDirectory:@"Images/otherImage"]];
    [self.slider setThumbImage:image forState:UIControlStateNormal];
    [self.slider setThumbImage:image forState:UIControlStateHighlighted];
    [self.slider setMinimumTrackTintColor:UIColorFromRGB(0xff783f)];
    [self.slider setMaximumTrackTintColor:UIColorFromRGB(0xefefef)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.slider];
}

-(void)sliderValueChanged:(UISlider *)slider{
    self.defaultLineWidth = slider.value;
    if (self.typeLineDelegate && [self.typeLineDelegate respondsToSelector:@selector(changeLineWidth:)]) {
        [self.typeLineDelegate changeLineWidth:self.defaultLineWidth];
    }
}
@end
