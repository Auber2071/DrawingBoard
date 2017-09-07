//
//  DrawBoardView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "DrawBoardView.h"
#import "LineModel.h"

#define PI 3.14159265358979323846

@interface DrawBoardView ()
@property (nonatomic, assign) DrawingStatus drawStatus;//绘制状态

@property (nonatomic, strong) NSMutableArray<NSValue*> *pointMutArr;//当前绘制的线条的点坐标集合


@property (nonatomic, strong) NSMutableArray<LineModel *> *linesMutArr;
@property (nonatomic, strong) NSMutableArray<LineModel *> *removedLinesMutArr;//删除的线条
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelMutArr;
@property (nonatomic, strong) LineModel *currentLine;



@end

@implementation DrawBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        self.backgroundColor = [UIColor clearColor];
        _pointMutArr = [NSMutableArray array];
        _linesMutArr = [NSMutableArray array];
        _removedLinesMutArr = [NSMutableArray array];
        _labelMutArr = [NSMutableArray array];
                
        _drawStatus = DrawingStatusEnd;
        
    }
    return self;
}
#pragma mark - 画图
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [self p_drawPath:context line:self.currentLine];
    for (int j = 0 ; j < [self.linesMutArr count]; j++) {
        LineModel *line = [self.linesMutArr objectAtIndex:j];
        [self p_drawPath:context line:line];
    }
}

-(void)p_drawPath:(CGContextRef)context line:(LineModel *)line{
    UIColor *color = (line.editType == EditMenuTypeOptionEraser ? [UIColor clearColor] : line.lineColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, line.lineWidth);
    CGBlendMode blendMode = (line.editType == EditMenuTypeOptionEraser ? kCGBlendModeDestinationIn : kCGBlendModeNormal);
    CGContextSetBlendMode(context, blendMode);
    
    switch (line.editType) {
            
        case EditMenuTypeOptionRect:{
            CGPoint point1 = [[line.lineTrackMutArr firstObject] CGPointValue];
            CGPoint point2 = [[line.lineTrackMutArr lastObject] CGPointValue];
            CGRect frame = CGRectMake(point1.x, point1.y, point2.x-point1.x, point2.y-point1.y);
            switch (line.rectType) {
                case RectTypeOptionEllipse:{
                    CGContextStrokeEllipseInRect(context, frame);
                }
                    break;
                case RectTypeOptionSquare:{
                    CGContextStrokeRect(context, frame);
                }
                    break;
                case RectTypeOptionArrows:{
                    
                }
                    break;
            }
        }
            break;
        default:{
            
            for (int i = 1;i < line.lineTrackMutArr.count; i++){
                CGPoint point1 = [[line.lineTrackMutArr objectAtIndex:i-1] CGPointValue];
                CGPoint point2 = [[line.lineTrackMutArr objectAtIndex:(i)] CGPointValue];
                CGContextMoveToPoint(context, point1.x, point1.y);
                CGContextAddLineToPoint(context, point2.x, point2.y);
                CGContextStrokePath(context);
            }
        }
            break;
    }
}
#pragma mark - touch系列方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.currentLine = [[LineModel alloc] initWithLineColor:self.lineColor lineWidth:self.lineWidth editType:self.editTypeOption rectType:self.rectTypeOption];

    CGPoint point = [self touchPointWithTouchEvent:event];
    //NSLog(@"touch begin x:%f y:%f",point.x,point.y);
    [self.pointMutArr addObject:[NSValue valueWithCGPoint:point]];
    self.currentLine.lineTrackMutArr = [self.pointMutArr copy];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:)]) {
        if (self.drawStatus == DrawingStatusEnd) {
            [self.delegate drawBoard:self drawingStatus:DrawingStatusBegin];
            self.drawStatus = DrawingStatusBegin;
        }else if(self.drawStatus == DrawingStatusBegin){
            [self.delegate drawBoard:self drawingStatus:DrawingStatusEnd];
            self.drawStatus = DrawingStatusEnd;
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self touchPointWithTouchEvent:event];
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    [self.pointMutArr addObject: pointValue];
    self.currentLine.lineTrackMutArr = [self.pointMutArr copy];

    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:)]) {
        [self.delegate drawBoard:self drawingStatus:DrawingStatusMove];
    }
    
    self.drawStatus = DrawingStatusMove;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.drawStatus != DrawingStatusMove) {
        [self.pointMutArr removeAllObjects];
        return;
    }
    
    if (self.pointMutArr.count>1) {
        [self.linesMutArr addObject:self.currentLine];
    }
    
    [self.pointMutArr removeAllObjects];
    [self setNeedsDisplay];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:)]) {
        [self.delegate drawBoard:self drawingStatus:DrawingStatusEnd];
        self.drawStatus = DrawingStatusEnd;
    }
}

-(CGPoint)touchPointWithTouchEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    return point;
}


#pragma mark - Resert SET Method
-(void)setEditTypeOption:(EditMenuTypeOptions)editTypeOption{
    _editTypeOption = editTypeOption;
    switch (editTypeOption) {
        case EditMenuTypeOptionCharacter://文本
        case EditMenuTypeOptionLine://线条
        case EditMenuTypeOptionRect://方形
        case EditMenuTypeOptionEraser://橡皮
            break;
        case EditMenuTypeOptionBack:{
            if (self.linesMutArr.count>0) {
                LineModel *tempLastLine = [self.linesMutArr lastObject];
                [self.removedLinesMutArr addObject:tempLastLine];
                [self.linesMutArr removeLastObject];
                [self setNeedsDisplay];
            }
        }
            break;
    }
}
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
}





#pragma mark - 文字输入&缩放移动手势

-(void)addLabelWithText:(NSString *)text textColor:(UIColor *)textColor{
    CGFloat width = 100.f;
    CGFloat height = 40.f;
    CGFloat X = ([[UIScreen mainScreen]bounds].size.width-width)/2.f;
    CGFloat Y = ([[UIScreen mainScreen]bounds].size.height-height)/2.f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1.f;
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    [self addSubview:label];
    
    [self addGestureTarget:label];
    [self.labelMutArr addObject:label];
}
#pragma mark 添加手势
-(void)addGestureTarget:(UILabel *)label{
    /*添加拖动手势*/
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panLabel:)];
    [label addGestureRecognizer:panGesture];

    
    /*添加捏合手势*/
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchLabel:)];
    [label addGestureRecognizer:pinchGesture];
    
    /*添加旋转手势*/
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateLabel:)];
    [label addGestureRecognizer:rotationGesture];
}
#pragma mark 拖动图片
-(void)panLabel:(UIPanGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //利用拖动手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
        CGPoint translation = [gesture translationInView:self];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                             gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

#pragma mark 捏合时缩放图片
-(void)pinchLabel:(UIPinchGestureRecognizer *)gesture{
    
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //捏合手势中scale属性记录的缩放比例
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
}

#pragma mark 旋转图片
-(void)rotateLabel:(UIRotationGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //旋转手势中rotation属性记录了旋转弧度
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        gesture.rotation = 0;
    }
}


@end
