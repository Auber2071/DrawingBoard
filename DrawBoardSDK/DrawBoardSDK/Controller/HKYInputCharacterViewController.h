//
//  HKYInputCharacterViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/5.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKYInputCharacterViewController;

@protocol HKYInputCharacterViewControllerDelegate <NSObject>

-(void)InputCharacterView:(HKYInputCharacterViewController *)inputCharacter text:(NSString *)text textColor:(UIColor *)textColor;

@end

@interface HKYInputCharacterViewController : UIViewController

@property (nonatomic, assign) id<HKYInputCharacterViewControllerDelegate> inPutCharacterDelegate;
- (instancetype)initWithColorArr:(NSArray *)colorArr defaultColorIndex:(NSInteger)defaultColorIndex;

@end
