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

@property (nonatomic) BOOL showAsixX;       //显示X轴
@property (nonatomic) BOOL showAsixY;       //显示Y轴
@property (nonatomic) BOOL showPointX;      //显示X轴虚线标线
@property (nonatomic) BOOL showPointY;      //显示Y轴虚线标线
@property (nonatomic) BOOL showTitleX;      //显示X轴标签
@property (nonatomic) BOOL showTitleY;      //显示Y轴标签

@property (nonatomic) ENUM_STARTLINE startPoint;    //设置点的起始位置

@property (nonatomic, strong) NSArray *dataX;       //设置X轴标记数据，不从0开始 例：@[@"1",@"2"]
@property (nonatomic, strong) NSArray *dataY;       //设置Y轴标记数据，不从0开始 例：@[@"1",@"2"]
@property (nonatomic, strong) NSArray *pointSet;    //设置内容点坐标 例：@[@[@"1",@"1"]]

@property (nonatomic, copy) ZJLineChartPlugBlock block;

@end
