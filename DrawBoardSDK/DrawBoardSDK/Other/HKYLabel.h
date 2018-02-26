//
//  HKYLabel.h
//  DrawBoard
//
//  Created by hankai on 2017/9/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKYLabel;

@protocol HKYLabelDelegate <NSObject>
-(void)tapLabelWithTag:(NSInteger)tag;

@end

@interface HKYLabel : UILabel
@property (nonatomic, assign) id<HKYLabelDelegate> labelDelegate;

-(void)hideBorder;
@end
