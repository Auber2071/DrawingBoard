//
//  HKYLabel.m
//  DrawBoard
//
//  Created by hankai on 2017/9/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYLabel.h"

//static NSTimeInterval HKYTimerInterval = 2.f;
@implementation HKYLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        [self addGestureTarget];
        //详解：http://www.cocoachina.com
        //不管是重复性的timer还是一次性的timer都会对它的方法的接收者进行retain，这两种timer的区别在于“一次性的timer在完成调用以后会自动将自己invalidate，而重复的timer则将永生，直到你显示的invalidate它为止”。
        /*
        __weak typeof(self) tempSelf = self;
            [NSTimer scheduledTimerWithTimeInterval:HKYTimerInterval repeats:NO block:^(NSTimer * _Nonnull timer) {
                tempSelf.layer.borderWidth = 0.f;
            }];
        */
    }
    return self;
}

#pragma mark 添加手势
-(void)addGestureTarget{
    /*添加点击手势*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [self addGestureRecognizer:tapGesture];
    
    /*添加拖动手势*/
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panLabel:)];
    [self addGestureRecognizer:panGesture];
    
    /*添加捏合手势*/
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchLabel:)];
    [self addGestureRecognizer:pinchGesture];
    
    /*添加旋转手势*/
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateLabel:)];
    [self addGestureRecognizer:rotationGesture];
}

#pragma mark 点击
-(void)tapLabel:(UITapGestureRecognizer *)gesture{
    //NSLog(@"%s",__func__);
    if (self.labelDelegate && [self.labelDelegate respondsToSelector:@selector(tapLabelWithTag:)]) {
        [self.labelDelegate tapLabelWithTag:self.tag];
    }
}

#pragma mark 拖动
-(void)panLabel:(UIPanGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //利用拖动手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
        CGPoint translation = [gesture translationInView:self.superview];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                          gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self.superview];
        //NSLog(@"%s-------%ld",__FUNCTION__,(long)gesture.state);
    }else{
        //NSLog(@"out-%s-------%ld",__FUNCTION__,(long)gesture.state);
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

-(void)hideBorder{
    self.layer.borderWidth = 0.f;
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
    //NSLog(@"%s",__func__);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

@end
/*
//  以下这种timer的用法，企图在dealloc中对timer进行invalidate是一种自欺欺人的做法
//  因为你的timer对self进行了retain，如果timer一直有效，则self的引用计数永远不会等于0
#import "SvCheatYourself.h"
@interface SvCheatYourself () {
    
    NSTimer *_timer;
    
}
@end
@implementation SvCheatYourself

- (id)init
{
    self = [super init];
    if (self) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer:) userInfo:nil repeats:YES];
        
    }
    
    return self;
}
- (void)dealloc
{
    // 自欺欺人的写法，永远都不会执行到，除非你在外部手动invalidate这个timer
    [_timer invalidate];
    
    [super dealloc];
}
- (void)testTimer:(NSTimer*)timer
{
    NSLog(@"haha!");
}
@end
*/
