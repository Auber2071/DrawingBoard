//
//  HKYDrawBoardView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "HKYDrawBoardView.h"
#import "HKYLineModel.h"
#import "HKYLabel.h"

@interface HKYDrawBoardView ()<HKYLabelDelegate>
@property (nonatomic, assign) DrawingStatus drawStatus;//绘制状态

@property (nonatomic, strong) NSMutableArray<NSValue*> *pointMutArr;//当前绘制的线条的点坐标集合

@property (nonatomic, strong) NSMutableArray<HKYLineModel *> *linesMutArr;
@property (nonatomic, strong) NSMutableArray<HKYLineModel *> *removedLinesMutArr;//删除的线条
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelMutArr;
@property (nonatomic, strong) HKYLineModel *currentLine;

@end

@implementation HKYDrawBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.userInteractionEnabled = NO;
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
        HKYLineModel *line = [self.linesMutArr objectAtIndex:j];
        [self p_drawPath:context line:line];
    }
}

-(void)p_drawPath:(CGContextRef)context line:(HKYLineModel *)line{
    if (line == nil) {
        return;
    }
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
                    CGFloat width = 20.f;
                    
                    CGFloat xDistance = point2.x - point1.x;
                    CGFloat yDistance = point2.y - point1.y;
                    CGFloat angle = atan2f(yDistance, xDistance);
                    CGFloat angle1 = angle + M_PI/6.f;
                    CGFloat angle2 = angle - M_PI/6.f;
                    
                    CGPoint upPoint = [self p_newPointWithAngle:angle1 point:point2 trigonWidth:width];
                    CGPoint downPoint = [self p_newPointWithAngle:angle2 point:point2 trigonWidth:width];

                    CGContextMoveToPoint(context, point2.x, point2.y);
                    CGContextAddLineToPoint(context, upPoint.x, upPoint.y);
                    CGContextAddLineToPoint(context, downPoint.x, downPoint.y);
                    CGContextAddLineToPoint(context, point2.x, point2.y);
                    CGContextSetLineWidth(context, 3);
                    CGContextSetFillColorWithColor(context,color.CGColor);
                    CGContextFillPath(context);
                    CGContextStrokePath(context);

                    
                    
                    xDistance = point2.x - upPoint.x;
                    yDistance = point2.y - upPoint.y;
                    CGPoint pointBottom1 = CGPointMake(point2.x - xDistance/2.f, point2.y - yDistance/2.f);
                    xDistance = point2.x - downPoint.x;
                    yDistance = point2.y - downPoint.y;
                    CGPoint pointBottom2 = CGPointMake(point2.x - xDistance/2.f, point2.y - yDistance/2.f);
                    CGContextMoveToPoint(context, pointBottom1.x, pointBottom1.y);
                    CGContextAddLineToPoint(context, pointBottom2.x, pointBottom2.y);
                    CGContextAddLineToPoint(context, point1.x, point1.y);
                    CGContextAddLineToPoint(context, pointBottom1.x, pointBottom1.y);
                    CGContextSetLineWidth(context, 3);
                    CGContextSetFillColorWithColor(context,color.CGColor);
                    CGContextFillPath(context);
                    CGContextStrokePath(context);
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

-(CGPoint)p_newPointWithAngle:(CGFloat)angle point:(CGPoint)point trigonWidth:(CGFloat)trigonWidth{
    CGFloat yDist = sin(angle)*trigonWidth;
    CGFloat xDist = cos(angle)*trigonWidth;
    CGPoint newPoint = CGPointMake(point.x - xDist, point.y - yDist);
    return newPoint;
}

#pragma mark - touch系列方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"%s",__FUNCTION__);

    self.currentLine = [[HKYLineModel alloc] initWithLineColor:self.lineColor lineWidth:self.lineWidth editType:self.editTypeOption rectType:self.rectTypeOption];

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
    //NSLog(@"%s",__FUNCTION__);

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
    //NSLog(@"%s",__FUNCTION__);

    if (self.drawStatus != DrawingStatusMove) {
        [self.pointMutArr removeAllObjects];
        return;
    }
    
    if (self.pointMutArr.count>1) {
        [self.linesMutArr addObject:self.currentLine];
    }
    
    [self.pointMutArr removeAllObjects];
    [self setNeedsDisplay];
    self.currentLine = nil;
    
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
    self.userInteractionEnabled = YES;
    switch (editTypeOption) {
        case EditMenuTypeOptionCharacter://文本
        case EditMenuTypeOptionLine://线条
        case EditMenuTypeOptionRect://方形
        case EditMenuTypeOptionEraser://橡皮
            break;
        case EditMenuTypeOptionBack:{
            if (self.linesMutArr.count>0) {
                HKYLineModel *tempLastLine = [self.linesMutArr lastObject];
                [self.removedLinesMutArr addObject:tempLastLine];
                [self.linesMutArr removeLastObject];
                [self setNeedsDisplay];
            }
        }
            break;
    }
}


#pragma mark - 文字输入&缩放移动手势
-(void)setupLabelWithTextModel:(HKYTextModel *)textModel{

    CGFloat height = 40.f;
    CGFloat width = [self calculateRowWidth:textModel.text withHeight:height];
    
    if (!textModel.isFixed && textModel.text.length >0) {
        CGFloat X = ([[UIScreen mainScreen]bounds].size.width-width)/2.f;
        CGFloat Y = ([[UIScreen mainScreen]bounds].size.height-height)/2.f;
        
        HKYLabel *label = [[HKYLabel alloc] initWithFrame:CGRectMake(X, Y, width, height)];
        label.labelDelegate = self;
        label.text = textModel.text;
        label.textColor = textModel.textColor;
        label.tag = textModel.tag;
        [self addSubview:label];
        [self.labelMutArr addObject:label];
    }else{
        for (UILabel *label in self.labelMutArr) {
            if (textModel.text.length<1) {
                [self.labelMutArr removeObject:label];
                [label removeFromSuperview];
                textModel.isFixed = NO;
                return;
            }
            if (label.tag == textModel.tag) {
                label.width = width;
                label.text = textModel.text;
                label.textColor = textModel.textColor;
                textModel.isFixed = NO;
            }
        }
    }
}

-(void)tapLabelWithTag:(NSInteger)tag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawBoardBtnClickWithTag:)]) {
        [self.delegate drawBoardBtnClickWithTag:tag];
    }
}

- (CGFloat)calculateRowWidth:(NSString *)string withHeight:(CGFloat)height{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}


@end
