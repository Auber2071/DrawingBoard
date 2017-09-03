//
//  ViewController.m
//  DrawingBoard
//
//  Created by hankai on 2017/8/22.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "ViewController.h"
#import "TempViewController.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"画板" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 100, 60, 40)];
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)clickBtn:(id)sender {
    TempViewController *tempVC = [[TempViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tempVC];
    [self presentViewController:navi animated:YES completion:nil];
}





/*
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
