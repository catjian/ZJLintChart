//
//  ZJLineChartPlug.h
//  ZJLintChart
//
//  Created by jian zhang on 16/7/29.
//  Copyright © 2016年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZJLineChartPlugBlock)(NSArray *pointContent, CGPoint point);

typedef NS_ENUM(NSUInteger, ENUM_STARTLINE) {
    ENUM_STARTLINE_BOTTOM,
    ENUM_STARTLINE_MIDDLE,
    ENUM_STARTLINE_TOP,
};

@interface ZJLineChartPlug : UIScrollView

@property (nonatomic) BOOL showX;
@property (nonatomic) BOOL showY;
@property (nonatomic) BOOL showPointX;
@property (nonatomic) BOOL showPointY;

@property (nonatomic) ENUM_STARTLINE startPoint;

@property (nonatomic, strong) NSArray *dataX;
@property (nonatomic, strong) NSArray *dataY;
@property (nonatomic, strong) NSArray *pointSet;

@property (nonatomic, copy) ZJLineChartPlugBlock block;

@end
