//
//  InputCharacterViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/5.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputCharacterViewController;

@protocol InputCharacterViewControllerDelegate <NSObject>

-(void)InputCharacterView:(InputCharacterViewController *)inputCharacter text:(NSString *)text textColor:(UIColor *)textColor;

@end

@interface InputCharacterViewController : UIViewController

@property (nonatomic, assign) id<InputCharacterViewControllerDelegate> inPutCharacterDelegate;

@end
