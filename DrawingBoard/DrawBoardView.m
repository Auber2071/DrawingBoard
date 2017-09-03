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

@interface DrawBoardView ()<UITextFieldDelegate>
@property (nonatomic, assign) DrawingStatus drawStatus;//绘制状态
@property (nonatomic, assign) EditMenuType selectedEditType;


@property (nonatomic, assign) CGFloat lineW;//当前线条宽度
@property (nonatomic, strong) UIColor *lineColor;//当前线条颜色
@property (nonatomic, strong) UIColor *tempLineColor;//存储切换橡皮擦之前的线条颜色

@property (nonatomic, strong) NSMutableArray<NSValue*> *pointMutArr;//当前绘制的线条的点坐标集合

@property (nonatomic, strong) NSMutableArray<LineModel *> *linesMutArr;
@property (nonatomic, strong) NSMutableArray<LineModel *> *removedLinesMutArr;//删除的线条
@property (nonatomic, strong) NSMutableArray<UITextField *> *textFieldMutArr;


@property (nonatomic, assign) NSInteger textFieldTag;
@property (nonatomic, strong) UITextField *textField;

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
        _textFieldMutArr = [NSMutableArray array];
        
        _lineW = 5.f;
        
        _tempLineColor = [UIColor redColor];
        _lineColor = _tempLineColor;
        _drawStatus = DrawingStatusEnd;
        _selectedEditType = EditMenuTypeLine;
        
        _textFieldTag = 0;
        
        __weak typeof(self) tempSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:EditMenuTypeChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [tempSelf p_modificateTheDrawBoardViewWith:[[note.userInfo objectForKey:@"selectedEditMenuType"] integerValue]];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:EditMenuLineColorChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            tempSelf.lineColor = (UIColor *)[note.userInfo objectForKey:@"lineColor"];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:EditMenuLineWidthChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            tempSelf.lineW = [[note.userInfo objectForKey:@"lineWidth"] floatValue];
        }];
        
    }
    return self;
}
#pragma mark - 画图
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [self p_drawOldPath:context];
    [self p_drawCurrentPath:context];
}
-(void)p_drawCurrentPath:(CGContextRef)context{//当前path
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, self.lineW);
    CGBlendMode blendMode = self.selectedEditType == EditMenuTypeEraser ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
    CGContextSetBlendMode(context, blendMode);
    
    switch (self.selectedEditType) {
        case EditMenuTypeRect:{
            CGPoint point1 = [[self.pointMutArr firstObject] CGPointValue];
            CGPoint point2 = [[self.pointMutArr lastObject] CGPointValue];
            CGRect frame = CGRectMake(point1.x, point1.y, point2.x-point1.x, point2.y-point1.y);
            CGContextStrokeRect(context, frame);
        }
            break;
        default:{
            for (int i = 0; i<((int)self.pointMutArr.count - 1); i++) {
                CGPoint point1 = [[self.pointMutArr objectAtIndex:i] CGPointValue];
                CGPoint point2 = [[self.pointMutArr objectAtIndex:(i+1)] CGPointValue];
                CGContextMoveToPoint(context, point1.x, point1.y);
                CGContextAddLineToPoint(context, point2.x, point2.y);
                CGContextStrokePath(context);
            }
        }
            break;
    }
}

-(void)p_drawOldPath:(CGContextRef)context{//历史path
    for (int j = 0 ; j < [self.linesMutArr count]; j++) {
        LineModel *line = [self.linesMutArr objectAtIndex:j];
        CGContextSetStrokeColorWithColor(context, line.lineColor.CGColor);
        CGContextSetLineWidth(context, line.lineWidth);
        
        switch (line.lineType) {

            case EditMenuTypeRect:{
                CGContextStrokeRect(context, [self p_drawRectOrEllipseWithLine:line]);
            }
                break;
            default:{
                //直线或曲线
                CGBlendMode blendMode = kCGBlendModeNormal;
                if (line.lineType == EditMenuTypeEraser) {
                    blendMode = kCGBlendModeDestinationIn;
                }
                CGContextSetBlendMode(context, blendMode);

                for (int i = 0;i < line.lineTrackMutArr.count-1; i++){
                    CGPoint point1 = [[line.lineTrackMutArr objectAtIndex:i] CGPointValue];
                    CGPoint point2 = [[line.lineTrackMutArr objectAtIndex:(i+1)] CGPointValue];
                    CGContextMoveToPoint(context, point1.x, point1.y);
                    CGContextAddLineToPoint(context, point2.x, point2.y);
                    CGContextStrokePath(context);
                }
            }
                break;
        }
    }
}


-(CGRect)p_drawRectOrEllipseWithLine:(LineModel *)line{
    CGPoint point1 = [[line.lineTrackMutArr firstObject] CGPointValue];
    CGPoint point2 = [[line.lineTrackMutArr lastObject] CGPointValue];
    CGRect frame = CGRectMake(point1.x, point1.y, point2.x-point1.x, point2.y-point1.y);
    return frame;
}


#pragma mark - touch系列方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
        for (UITextField *testField in self.textFieldMutArr) {
            if (testField.text.length<1) {
                [self.textFieldMutArr removeObject:testField];
            }
        }
        return;
    }
    
    CGPoint point = [self touchPointWithTouchEvent:event];
    NSLog(@"touch begin x:%f y:%f",point.x,point.y);
    [self.pointMutArr addObject:[NSValue valueWithCGPoint:point]];
    
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
    CGPoint point = [self touchPointWithTouchEvent:event];
    NSLog(@"touch end x:%f y:%f",point.x,point.y);
    
    if (self.pointMutArr.count>1) {
        LineModel *line = [[LineModel alloc] initWithLineTrack:[self.pointMutArr copy] lineColor:self.lineColor lineWidth:self.lineW lineType:self.selectedEditType];
        [self.linesMutArr addObject:line];
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

#pragma mark - EditViewTypeDidSelectec
-(void)p_modificateTheDrawBoardViewWith:(EditMenuType)selectMenuType{
    self.selectedEditType = selectMenuType;
    switch (selectMenuType) {
        case EditMenuTypeLine://线条
        case EditMenuTypeRect://方形
            self.lineColor = self.tempLineColor;
            break;
        case EditMenuTypeCharacter:{//文本
            self.lineColor = self.tempLineColor;
            [self printSomething];
        }
            break;
        case EditMenuTypeEraser:{//橡皮
            self.tempLineColor = [self.lineColor isEqual:[UIColor clearColor]] ? self.tempLineColor : [self.lineColor copy];
            self.lineColor = [UIColor clearColor];
        }
            break;
        case EditMenuTypeBack:{
            if (self.linesMutArr.count>0) {
                self.lineColor = self.tempLineColor;
                
                LineModel *tempLastLine = [self.linesMutArr lastObject];
                [self.removedLinesMutArr addObject:tempLastLine];
                [self.linesMutArr removeLastObject];
                [self setNeedsDisplay];
                
            }
        }
            break;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 文字输入&缩放移动手势
-(void)printSomething{
    
    CGFloat width = 100.f;
    CGFloat height = 40.f;
    CGFloat X = ([[UIScreen mainScreen]bounds].size.width-width)/2.f;
    CGFloat Y = ([[UIScreen mainScreen]bounds].size.height-height)/2.f;
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(X, Y, width, height)];
    self.textField.textColor = [self.lineColor copy];
    self.textField.adjustsFontSizeToFitWidth = YES;
    self.textField.layer.borderColor = [UIColor purpleColor].CGColor;
    self.textField.layer.borderWidth = 1.f;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.tag = self.textFieldTag;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;//设置return键样式
    self.textField.keyboardType = UIKeyboardTypeDefault;//键盘样式
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//设置自动大写方式
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;//设置自动纠错
    [self.textField addTarget:self action:@selector(resignResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addSubview:self.textField];
    [self.textField becomeFirstResponder];
    
    [self addGesture];
    self.textFieldTag++;
    
    [self.textFieldMutArr addObject:self.textField];
}


-(void)resignResponder:(UITextField *)textField{
    [textField resignFirstResponder];
    for (UITextField *testField in self.textFieldMutArr) {
        if (testField.text.length<1) {
            [self.textFieldMutArr removeObject:testField];
        }
    }
}



#pragma mark 添加手势
-(void)addGesture{
    /*添加拖动手势*/
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTextField:)];
    [self.textField addGestureRecognizer:panGesture];

    
    /*添加捏合手势*/
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchTextField:)];
    [self.textField addGestureRecognizer:pinchGesture];
    
    /*添加旋转手势*/
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateTextField:)];
    [self.textField addGestureRecognizer:rotationGesture];
}
#pragma mark 拖动图片
-(void)panTextField:(UIPanGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //利用拖动手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
        CGPoint translation = [gesture translationInView:self];
        gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
                                             gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

#pragma mark 捏合时缩放图片
-(void)pinchTextField:(UIPinchGestureRecognizer *)gesture{
    
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //捏合手势中scale属性记录的缩放比例
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
}


#pragma mark 旋转图片
-(void)rotateTextField:(UIRotationGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateChanged) {
        //旋转手势中rotation属性记录了旋转弧度
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        gesture.rotation = 0;
    }
}



@end
