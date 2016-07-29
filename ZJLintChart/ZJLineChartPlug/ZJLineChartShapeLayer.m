//
//  ZJLineChartShapeLayer.m
//  ZJLintChart
//
//  Created by jian zhang on 16/7/29.
//  Copyright © 2016年 jian zhang. All rights reserved.
//

#import "ZJLineChartShapeLayer.h"

static ZJLineChartShapeLayer *lineChartLayer = nil;

@implementation ZJLineChartShapeLayer

+ (ZJLineChartShapeLayer *)sharedLineChartShapeLayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineChartLayer = [[ZJLineChartShapeLayer alloc] init];
    });
    return lineChartLayer;
}

- (CALayer *)drawRoundWithPoint:(CGPoint)point Size:(CGSize)size LineWidth:(CGFloat)width LineColor:(UIColor *)lineColor BackGroundColor:(UIColor *)bgColor
{
    CAShapeLayer *solidRound =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidRound.lineWidth = width ;
    solidRound.strokeColor = lineColor.CGColor;
    solidRound.fillColor = bgColor.CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(point.x,  point.y, size.width, size.height));
    solidRound.path = solidPath;
    CGPathRelease(solidPath);
    return solidRound;
}

- (CALayer *)drawLineWithStartPoint:(CGPoint)sPoint EndPoint:(CGPoint)ePoint LineWidth:(CGFloat)width LineColor:(UIColor *)color isDotte:(BOOL)dotte
{
    CAShapeLayer *solidLine = [CAShapeLayer layer];
    UIBezierPath *solidShapePath =  [UIBezierPath bezierPath];
    [solidLine setFillColor:[[UIColor clearColor] CGColor]];
    [solidLine setStrokeColor:[color CGColor]];
    solidLine.lineWidth = width ;
    if (dotte)
    {
        NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1], nil];
        [solidLine setLineDashPattern:dotteShapeArr];
    }
    
    [solidShapePath moveToPoint:sPoint];
    [solidShapePath addLineToPoint:ePoint];
    [solidLine setPath:solidShapePath.CGPath];
    return solidLine;
}

- (CALayer *)drawBezierRoundWithPoint:(CGPoint)point Size:(CGSize)size LineWidth:(CGFloat)width LineColor:(UIColor *)lineColor BackGroundColor:(UIColor *)bgColor cornerRadius:(CGFloat)radius
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){point,size} cornerRadius:radius];
    CAShapeLayer *solidRound =  [CAShapeLayer layer];
    solidRound.lineWidth = width ;
    solidRound.strokeColor = lineColor.CGColor;
    solidRound.fillColor = bgColor.CGColor;
    solidRound.path = path.CGPath;
    
    return solidRound;
}

- (CALayer *)drawBezierLineWithPoints:(NSArray<NSValue *> *)pointArr LineWidth:(CGFloat)width LineColor:(UIColor *)color isDotte:(BOOL)dotte
{
    if (pointArr.count < 2)
    {
        return nil;
    }
    CAShapeLayer *solidLine = [CAShapeLayer layer];
    UIBezierPath *bezPath = [UIBezierPath bezierPath];
    [solidLine setFillColor:[[UIColor clearColor] CGColor]];
    [solidLine setStrokeColor:[color CGColor]];
    solidLine.lineWidth = width ;
    if (dotte)
    {
        NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
        [solidLine setLineDashPattern:dotteShapeArr];
    }
    
    if (pointArr.count == 3)
    {
        [bezPath moveToPoint:[[pointArr firstObject] CGPointValue]];
        [bezPath addQuadCurveToPoint:[[pointArr lastObject] CGPointValue] controlPoint:[pointArr[1] CGPointValue]];
    }
    if (pointArr.count == 4)
    {
        [bezPath moveToPoint:[[pointArr firstObject] CGPointValue]];
        [bezPath addCurveToPoint:[[pointArr lastObject] CGPointValue] controlPoint1:[pointArr[1] CGPointValue] controlPoint2:[pointArr[2] CGPointValue]];
    }
    else
    {
        for (int i = 0; i+2 < pointArr.count; i += 2)
        {
            UIBezierPath *subPath = [UIBezierPath bezierPath];
            [bezPath moveToPoint:[pointArr[i] CGPointValue]];
            [bezPath addQuadCurveToPoint:[pointArr[i+2] CGPointValue] controlPoint:[pointArr[i+1] CGPointValue]];
            [bezPath appendPath:subPath];
        }
    }
    [solidLine setPath:bezPath.CGPath];
    [bezPath closePath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 3;
    [solidLine addAnimation:animation forKey:nil];
    
    return solidLine;
}

@end

@implementation CALayer (LayerAnimation)

- (CALayer *)AnimationWithStrokeEnd
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 3;
    [self addAnimation:animation forKey:nil];
    
    return self;
}

- (CALayer *)AnimationWithStrokeStart
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 3;
    [self addAnimation:animation forKey:nil];
    
    return self;
}

- (CALayer *)AnimationWithLineWidth
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.fromValue = @(1);
    animation.toValue = @(10);
    animation.duration = 3;
    [self addAnimation:animation forKey:nil];
    
    return self;
}

- (void)AnimationMoveFromValue:(CGPoint)frPoint
                      ToVaule:(CGPoint)toPoint
                     Duration:(CGFloat)duration
{
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    [newPath moveToPoint:frPoint];
    [newPath addLineToPoint:toPoint];
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.toValue = (id)newPath.CGPath;
    pathAnim.removedOnCompletion = NO;
    pathAnim.duration = duration;
    pathAnim.fillMode  = kCAFillModeForwards;
    [self addAnimation:pathAnim forKey:nil];
}

- (void)AnimationPointMoveToValue:(CGPoint)toPoint Duration:(CGFloat)duration
{
    CGPathRef solidShapePath = [(CAShapeLayer *)self path];
    UIBezierPath *bezPath =  [UIBezierPath bezierPathWithCGPath:solidShapePath];
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRoundedRect:(CGRect){toPoint,bezPath.bounds.size} cornerRadius:5];
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.toValue = (id)newPath.CGPath; pathAnim.removedOnCompletion = NO;
    pathAnim.duration = duration;
    pathAnim.fillMode  = kCAFillModeForwards;
    [self addAnimation:pathAnim forKey:nil];
}

@end
