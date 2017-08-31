//
//  ViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "ViewController.h"
#import "DrawBoard.h"

//#import "DrawBoardView.h"
//#import "EditView.h"

@interface ViewController ()
//@interface ViewController ()//<DrawBoardViewDeletage>
//@property (nonatomic, strong) UIImageView *backImageView;
//@property (nonatomic, strong) DrawBoardView *drawBoardView;
//@property (nonatomic, strong) EditView *editView;

@property (nonatomic, strong) DrawBoard *drawBoard;

@end

@implementation ViewController
-(DrawBoard *)drawBoard{
    if (!_drawBoard) {
        _drawBoard = [[DrawBoard alloc] initWithFrame:self.view.bounds];
    }
    return _drawBoard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.drawBoard];
    
    
    //[self.view addSubview:self.backImageView];
    //[self.view addSubview:self.drawBoardView];
    //[self.view addSubview:self.editView];
}



/*
-(void)drawBoard:(DrawBoardView *)drawView drawingStatus:(DrawingStatus)drawingStatus{

    __weak typeof(self) tempSelf = self;
    NSTimeInterval timerInterval = 0.5f;
    switch (drawingStatus) {
        case DrawingStatusBegin:{
            [UIView animateWithDuration:timerInterval animations:^{
                CGFloat Y =  CGRectGetHeight(tempSelf.view.frame);
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.view.frame), CGRectGetHeight(tempSelf.view.frame) - Y)];
            }];
        }
            break;
        case DrawingStatusMove:
            
            break;
        case DrawingStatusEnd:{
            [UIView animateWithDuration:timerInterval animations:^{
                CGFloat Y =  CGRectGetHeight(tempSelf.view.frame)/5*4;
                [tempSelf.editView setFrame:CGRectMake(0, Y, CGRectGetWidth(tempSelf.view.frame), CGRectGetHeight(tempSelf.view.frame) - Y)];
            }];
        }
            break;
        default:
            break;
    }
    
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView =  [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setImage:[UIImage imageNamed:@"Vencent.jpg"]];
    }
    return _backImageView;
}
-(DrawBoardView *)drawBoardView{
    if (!_drawBoardView) {
         _drawBoardView = [[DrawBoardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/5*4)];
        _drawBoardView.layer.borderColor = [UIColor redColor].CGColor;
        _drawBoardView.layer.borderWidth = 1.f;
        _drawBoardView.delegate = self;
    }
    return _drawBoardView;
}

-(EditView *)editView{
    if (!_editView) {
        CGFloat Y =  CGRectGetHeight(self.view.frame)/5*4;
        _editView = [[EditView alloc] initWithFrame:CGRectMake(0, Y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - Y)];
        //_editView.layer.borderColor = [UIColor orangeColor].CGColor;
        //_editView.layer.borderWidth = 1.f;

    }
    return _editView;
}





- (UIImage *)screenshot:(UIView *)shotView{
    //参数的含义：第一个参数表示所要创建的图片的尺寸；第二个参数用来指定所生成图片的背景是否为不透明，如上我们使用YES而不是NO，则我们得到的图片背景将会是黑色，显然这不是我想要的；第三个参数指定生成图片的缩放因子，这个缩放因子与UIImage的scale属性所指的含义是一致的。传入0则表示让图片的缩放因子根据屏幕的分辨率而变化，所以我们得到的图片不管是在单分辨率还是视网膜屏上看起来都会很好。
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [shotView.layer renderInContext:context];
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();//调用UIGraphicsGetImageFromCurrentImageContext函数可从当前上下文中获取一个UIImage对象。
    
    
    UIGraphicsEndImageContext();//UIGraphicsEndImageContext函数关闭图形上下文
    
    return getImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
@end
