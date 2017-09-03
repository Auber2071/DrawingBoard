//
//  DrawBoard.h
//  DrawingBoard
//
//  Created by hankai on 2017/8/25.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawBoard;
@protocol DrawBoardDelegate <NSObject>

-(void)cancelEdit;
-(void)finishEditWithImage:(UIImage *)finishImage;


@end

@interface DrawBoard : UIView
@property (nonatomic, assign) id<DrawBoardDelegate> drawBoardDelegate;

@end
