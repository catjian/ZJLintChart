//
//  ZJLineChartShapeLayer.h
//  ZJLintChart
//
//  Created by jian zhang on 16/7/29.
//  Copyright © 2016年 jian zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
#import <UIKit/UIBezierPath.h>
#import <UIKit/UIGeometry.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAShapeLayer.h>
#import <QuartzCore/CAMediaTimingFunction.h>

@interface ZJLineChartShapeLayer : NSObject

+ (ZJLineChartShapeLayer *)sharedLineChartShapeLayer;

- (CALayer *)drawRoundWithPoint:(CGPoint)point Size:(CGSize)size LineWidth:(CGFloat)width LineColor:(UIColor *)lineColor BackGroundColor:(UIColor *)bgColor;

- (CALayer *)drawLineWithStartPoint:(CGPoint)sPoint EndPoint:(CGPoint)ePoint LineWidth:(CGFloat)width LineColor:(UIColor *)color isDotte:(BOOL)dotte;

- (CALayer *)drawBezierRoundWithPoint:(CGPoint)point Size:(CGSize)size LineWidth:(CGFloat)width LineColor:(UIColor *)lineColor BackGroundColor:(UIColor *)bgColor cornerRadius:(CGFloat)radius;

- (CALayer *)drawBezierLineWithPoints:(NSArray<NSValue *> *)pointArr LineWidth:(CGFloat)width LineColor:(UIColor *)color isDotte:(BOOL)dotte;

@end

@interface CALayer (LayerAnimation)

- (void)AnimationMoveFromValue:(CGPoint)frPoint
                       ToVaule:(CGPoint)toPoint
                      Duration:(CGFloat)duration;

- (void)AnimationPointMoveToValue:(CGPoint)toPoint Duration:(CGFloat)duration;

@end
