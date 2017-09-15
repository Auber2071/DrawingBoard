//
//  HKYLabel.m
//  DrawBoard
//
//  Created by hankai on 2017/9/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYLabel.h"

@implementation HKYLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        [self addGestureTarget];
    }
    return self;
}

#pragma mark 添加手势
-(void)addGestureTarget{
    /*添加点击手势*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [self addGestureRecognizer:tapGesture];
    
    /*添加拖动手势*/
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panLabel:)];
    [self addGestureRecognizer:panGesture];
    
    
    /*添加捏合手势*/
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchLabel:)];
    [self addGestureRecognizer:pinchGesture];
    
    /*添加旋转手势*/
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateLabel:)];
    [self addGestureRecognizer:rotationGesture];
}

#pragma mark 点击
-(void)tapLabel:(UITapGestureRecognizer *)gesture{
    NSLog(@"tap:>>>>>>%s-------%ld",__FUNCTION__,(long)gesture.state);
}
#pragma mark 拖动
-(void)panLabel:(UIPanGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //利用拖动手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
        CGPoint translation = [gesture translationInView:self.superview];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                          gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self.superview];
        NSLog(@"%s-------%ld",__FUNCTION__,(long)gesture.state);
    }else{
        NSLog(@"out-%s-------%ld",__FUNCTION__,(long)gesture.state);
    }
}

#pragma mark 捏合
-(void)pinchLabel:(UIPinchGestureRecognizer *)gesture{
    
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //捏合手势中scale属性记录的缩放比例
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
}

#pragma mark 旋转
-(void)rotateLabel:(UIRotationGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //旋转手势中rotation属性记录了旋转弧度
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        gesture.rotation = 0;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

@end
