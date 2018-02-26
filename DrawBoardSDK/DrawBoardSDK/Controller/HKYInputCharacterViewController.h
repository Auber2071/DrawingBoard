//
//  HKYInputCharacterViewController.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/5.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKYInputCharacterViewController;
@class HKYTextModel;

@protocol HKYInputCharacterViewControllerDelegate <NSObject>
///文字编辑完成回调
-(void)InputCharacterView:(HKYInputCharacterViewController *)inputCharacter textModel:(HKYTextModel *)textModel;

@end

@interface HKYInputCharacterViewController : UIViewController

@property (nonatomic, assign) id<HKYInputCharacterViewControllerDelegate> inPutCharacterDelegate;
@property (nonatomic, strong) HKYTextModel *fixedTextModel;

- (instancetype)initWithColorArr:(NSArray *)colorArr defaultColorIndex:(NSInteger)defaultColorIndex;


@end
