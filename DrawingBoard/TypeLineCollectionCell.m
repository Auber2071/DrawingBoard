//
//  TypeLineCollectionCell.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/26.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "TypeLineCollectionCell.h"

@interface TypeLineCollectionCell ()
@property (nonatomic, strong) UISlider *slider;


@end

@implementation TypeLineCollectionCell

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
    UIEdgeInsets sliderInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(sliderInset.left, 0, CGRectGetWidth(frame) - sliderInset.left - sliderInset.right, CGRectGetHeight(frame))];
    self.slider.minimumValue = 5.f;
    self.slider.maximumValue = 20.f;
    self.slider.tintColor = [UIColor orangeColor];
    
    self.slider.value = self.defaultLineWidth;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.slider];
}

-(void)sliderValueChanged:(UISlider *)slider{
    NSLog(@"New value=%f",slider.value);
    self.defaultLineWidth = slider.value;
    if (self.typeLineDelegate && [self.typeLineDelegate respondsToSelector:@selector(changeLineWidth:)]) {
        [self.typeLineDelegate changeLineWidth:self.defaultLineWidth];
    }
}
@end
