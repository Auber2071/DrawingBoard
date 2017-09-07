//
//  DrawingBoardHeader.h
//  DrawingBoard
//
//  Created by hankai on 2017/9/6.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#ifndef DrawingBoardHeader_h
#define DrawingBoardHeader_h


typedef NS_ENUM(NSInteger,RectTypeOptions) {
    RectTypeOptionSquare,
    RectTypeOptionEllipse,
    RectTypeOptionArrows
};

//-------------------16进制色值转换-------------------------
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//-------------------屏幕尺寸-------------------------
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

#endif /* DrawingBoard_h */
