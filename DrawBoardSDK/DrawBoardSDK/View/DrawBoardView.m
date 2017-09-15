//
//  DrawBoardView.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "DrawBoardView.h"
#import "LineModel.h"
#import "HKYLabel.h"


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
    NSLog(@"%s",__FUNCTION__);

    self.currentLine = [[LineModel alloc] initWithLineColor:self.lineColor lineWidth:self.lineWidth editType:self.editTypeOption rectType:self.rectTypeOption];

    CGPoint point = [self touchPointWithTouchEvent:event];
    NSLog(@"touch begin x:%f y:%f",point.x,point.y);
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
    
    NSLog(@"%s",__FUNCTION__);

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
    NSLog(@"%s",__FUNCTION__);

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
    self.userInteractionEnabled = YES;
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
    
    HKYLabel *label = [[HKYLabel alloc] initWithFrame:CGRectMake(X, Y, width, height)];

    label.text = text;
    label.textColor = textColor;
    [self addSubview:label];
    
    [self.labelMutArr addObject:label];
}
@end
