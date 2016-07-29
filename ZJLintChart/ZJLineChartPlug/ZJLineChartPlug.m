//
//  ZJLineChartPlug.m
//  ZJLintChart
//
//  Created by jian zhang on 16/7/29.
//  Copyright © 2016年 jian zhang. All rights reserved.
//

#import "ZJLineChartPlug.h"
#import "ZJLineChartShapeLayer.h"

const CGFloat offset_start_x = 80;

#define SuberLayerNameKey @"SuberLayerNameKey"

@interface ZJLineChartPlug ()

@property (nonatomic, strong) NSMutableArray *AimsPoints;
@property (nonatomic, strong) NSMutableArray *BeginPoints;

@end

@implementation ZJLineChartPlug
{
    CGPoint m_StartPoint;
    CGFloat m_AsixXWidht;
    CGFloat m_AsixYHeight;
    CGPoint m_contentStartPoint;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setStartPoint:ENUM_STARTLINE_MIDDLE];
        m_StartPoint = CGPointMake(offset_start_x, frame.size.height-offset_start_x);
        CALayer *baseAxisX = [[ZJLineChartShapeLayer sharedLineChartShapeLayer]
                              drawLineWithStartPoint:m_StartPoint
                              EndPoint:CGPointMake(frame.size.width-10, m_StartPoint.y)
                              LineWidth:1
                              LineColor:[UIColor blackColor]
                              isDotte:YES];
        [baseAxisX setValue:@"BaseAxis_X" forKey:SuberLayerNameKey];
        [self.layer addSublayer:baseAxisX];
        
        CALayer *baseAxisY = [[ZJLineChartShapeLayer sharedLineChartShapeLayer]
                              drawLineWithStartPoint:m_StartPoint
                              EndPoint:CGPointMake(m_StartPoint.x, 10)
                              LineWidth:1
                              LineColor:[UIColor blackColor]
                              isDotte:YES];
        [baseAxisY setValue:@"BaseAxis_Y" forKey:SuberLayerNameKey];
        [self.layer addSublayer:baseAxisY];
        
        [self setContentSize:frame.size];
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    m_StartPoint = CGPointMake(offset_start_x, contentSize.height-offset_start_x);
    [[[self getSubLayerWithName:@"BaseAxis_X"] firstObject] AnimationMoveFromValue:m_StartPoint
                                                                           ToVaule:CGPointMake(contentSize.width-10, m_StartPoint.y)
                                                                          Duration:0];
    [[[self getSubLayerWithName:@"BaseAxis_Y"] firstObject] AnimationMoveFromValue:m_StartPoint
                                                                           ToVaule:CGPointMake(m_StartPoint.x, 10)
                                                                          Duration:0];
}

- (void)setShowX:(BOOL)showX
{
    if (!showX)
    {
        [[[self getSubLayerWithName:@"BaseAxis_X"] firstObject] removeFromSuperlayer];
    }
}

- (void)setShowY:(BOOL)showY
{
    if (!showY)
    {
        [[[self getSubLayerWithName:@"BaseAxis_Y"] firstObject] removeFromSuperlayer];
    }
}

- (void)setShowPointX:(BOOL)showPointX
{
    if (!showPointX)
    {
        [[self getSubLayerWithName:@"pointAxis_X"] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj valueForKey:SuberLayerNameKey] isEqualToString:@"pointAxis_X"])
            {
                [obj removeFromSuperlayer];
            }
        }];
    }
}

- (void)setStartPoint:(ENUM_STARTLINE)startPoint
{
    _startPoint = startPoint;
    CGFloat start_X = m_StartPoint.x + m_AsixXWidht/2;
    CGFloat start_Y = m_StartPoint.y - m_AsixYHeight/2;
    switch (startPoint)
    {
        case ENUM_STARTLINE_TOP:
        {
            m_contentStartPoint = CGPointMake(start_X,start_Y-((int)self.dataY.count-1)*m_AsixYHeight);
        }
            break;
        case ENUM_STARTLINE_BOTTOM:
        {
            m_contentStartPoint = CGPointMake(start_X,start_Y);
        }
            break;
        case ENUM_STARTLINE_MIDDLE:
        default:
        {
            m_contentStartPoint = CGPointMake(start_X,start_Y-((int)self.dataY.count/2)*m_AsixYHeight);
        }
            break;
    }
}

- (void)setShowPointY:(BOOL)showPointY
{
    if (!showPointY)
    {
        [[self getSubLayerWithName:@"pointAxis_Y"] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
    }
}

- (void)setDataX:(NSArray *)dataX
{
    _dataX = [dataX mutableCopy];
    m_AsixXWidht = (self.contentSize.width-m_StartPoint.x-10)/(dataX.count);
    for (int i = 0; i < dataX.count; i++)
    {
        CGRect rect = CGRectMake(m_StartPoint.x+i*m_AsixXWidht, m_StartPoint.y, m_AsixXWidht, 20);
        UILabel *lab = [[UILabel alloc] initWithFrame:rect];
        [lab setText:dataX[i]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lab];
        
        CGPoint dataPoint = CGPointMake(CGRectGetMidX(rect)-2, CGRectGetMinY(rect)-2);
        [self drawAxisPoint:dataPoint];
        [self drawAxisXLineWithStartPoint:dataPoint];
    }
}

- (void)setDataY:(NSArray *)dataY
{
    _dataY = dataY;
    m_AsixYHeight = (m_StartPoint.y-10)/(dataY.count);
    for (int i = 0; i < dataY.count; i++)
    {
        CGRect rect = CGRectMake(0, m_StartPoint.y-m_AsixYHeight-i*m_AsixYHeight,75, m_AsixYHeight);
        UILabel *lab = [[UILabel alloc] initWithFrame:rect];
        [lab setText:dataY[i]];
        [lab setTextAlignment:NSTextAlignmentRight];
        [self addSubview:lab];
        
        CGPoint dataPoint = CGPointMake(CGRectGetMaxX(rect)+3, CGRectGetMidY(rect)-2);
        [self drawAxisPoint:dataPoint];
        [self drawAxisYLineWithStartPoint:dataPoint];
    }
}

- (void)setPointSet:(NSArray *)pointSet
{
    _pointSet = pointSet;
    [self setStartPoint:self.startPoint];
    [self drawContentLine];
    [self drawContentPoint];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnimationToAimsPoint];
    });
}

#pragma mark - Actions 

- (NSArray <CALayer *> *)getSubLayerWithName:(NSString *)name
{
    NSMutableArray *objs = [NSMutableArray array];
    for (CALayer *obj in self.layer.sublayers)
    {
        if ([[obj valueForKey:SuberLayerNameKey] isEqualToString:name])
        {
            [objs addObject:obj];
        }
    }
    return objs;
}

#pragma mark - init Points

- (NSMutableArray *)BeginPoints
{
    if (!_BeginPoints)
    {
        _BeginPoints = [NSMutableArray array];
        for (int i = 0; i < self.pointSet.count; i++)
        {
            CGPoint point = CGPointMake(m_contentStartPoint.x+i*m_AsixXWidht, m_contentStartPoint.y);
            if (i+1 < self.pointSet.count)
            {
                CGPoint nextpoint = CGPointMake(m_contentStartPoint.x+(i+1) *m_AsixXWidht, m_contentStartPoint.y);
                [_BeginPoints addObject:@[[NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:nextpoint]]];
            }
        }
    }
    
    return _BeginPoints;
}

- (NSMutableArray *)AimsPoints
{
    if (!_AimsPoints)
    {
        _AimsPoints = [NSMutableArray array];
        CGFloat start_Y = m_StartPoint.y - m_AsixYHeight/2;
        for (int i = 0; i < self.pointSet.count; i++)
        {
            NSArray *content = self.pointSet[i];
            CGPoint point = CGPointMake(m_contentStartPoint.x+([[content firstObject] floatValue]-1)*m_AsixXWidht,
                                        start_Y-([[content lastObject] floatValue]-1)*m_AsixYHeight);
            if (i+1 < self.pointSet.count)
            {
                content = self.pointSet[i+1];
                CGPoint nextpoint = CGPointMake(m_contentStartPoint.x+([[content firstObject] floatValue]-1)*m_AsixXWidht,
                                                start_Y-([[content lastObject] floatValue]-1)*m_AsixYHeight);
                [_AimsPoints addObject:@[[NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:nextpoint]]];
            }
        }

    }    return _AimsPoints;
}

#pragma mark - Animations

- (void)startAnimationToAimsPoint
{
    for (int i = 0; i < self.AimsPoints.count; i++)
    {
        NSArray *content = self.AimsPoints[i];
        for (CALayer *obj in self.layer.sublayers)
        {
            if ([[obj valueForKey:SuberLayerNameKey] isEqualToString:[NSString stringWithFormat:@"pointLine_%d",i]])
            {
                [obj AnimationMoveFromValue:[[content firstObject] CGPointValue]
                                    ToVaule:[[content lastObject] CGPointValue] Duration:1.5];
            }
            if ([[obj valueForKey:SuberLayerNameKey] isEqualToString:[NSString stringWithFormat:@"pointSet_%d",i]])
            {
                CGPoint endPoint = [[content firstObject] CGPointValue];
                [obj AnimationPointMoveToValue:CGPointMake(endPoint.x-5,endPoint.y-5) Duration:1.5];
            }
            if (i+1 == self.AimsPoints.count)
            {
                if ([[obj valueForKey:SuberLayerNameKey] isEqualToString:[NSString stringWithFormat:@"pointSet_%d",i+1]])
                {
                    CGPoint endPoint = [[content lastObject] CGPointValue];
                    [obj AnimationPointMoveToValue:CGPointMake(endPoint.x-5,endPoint.y-5) Duration:1.5];
                }
            }
        }
    }
}

#pragma mark - Draw Axis Layer

- (void)drawAxisPoint:(CGPoint)point
{
    [self.layer addSublayer:[[ZJLineChartShapeLayer sharedLineChartShapeLayer] drawRoundWithPoint:point
                                                                                             Size:CGSizeMake(4, 4)
                                                                                        LineWidth:0
                                                                                        LineColor:nil
                                                                                  BackGroundColor:[UIColor whiteColor]]];
}

- (void)drawAxisXLineWithStartPoint:(CGPoint)point
{
    if (self.showPointX)
    {
        CALayer *axis = [[ZJLineChartShapeLayer sharedLineChartShapeLayer]
                         drawLineWithStartPoint:CGPointMake(point.x+2,point.y)
                         EndPoint:CGPointMake(point.x, 10)
                         LineWidth:1
                         LineColor:[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:0.8]
                         isDotte:YES];
        [axis setValue:@"pointAxis_X" forKey:SuberLayerNameKey];
        [self.layer addSublayer:axis];
    }
}

- (void)drawAxisYLineWithStartPoint:(CGPoint)point
{
    if (self.showPointY)
    {
        CALayer *axis = [[ZJLineChartShapeLayer sharedLineChartShapeLayer]
                         drawLineWithStartPoint:CGPointMake(point.x,point.y+2)
                         EndPoint:CGPointMake(self.contentSize.width-10, point.y)
                         LineWidth:1
                         LineColor:[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:0.8]
                         isDotte:YES];
        [axis setValue:@"pointAxis_Y" forKey:SuberLayerNameKey];
        [self.layer addSublayer:axis];
    }
}

#pragma mark - Draw Content layer

- (void)drawContentLine
{
    for (int i = 0; i < self.BeginPoints.count; i++)
    {
        NSArray *onePoint = self.BeginPoints[i];
        CGPoint startPoint = [[onePoint firstObject] CGPointValue];
        CGPoint endPoint = [[onePoint lastObject] CGPointValue];
        CALayer *pointLine = [[ZJLineChartShapeLayer sharedLineChartShapeLayer] drawLineWithStartPoint:startPoint EndPoint:endPoint LineWidth:1 LineColor:[UIColor whiteColor] isDotte:NO];
        [pointLine setValue:[NSString stringWithFormat:@"pointLine_%d",i] forKey:SuberLayerNameKey];
        [self.layer addSublayer:pointLine];
    }
}

- (void)drawContentPoint
{
    for (int i = 0; i < self.BeginPoints.count; i++)
    {
        NSArray *onePoint = self.BeginPoints[i];
        CGPoint startPoint = [[onePoint firstObject] CGPointValue];
        CGPoint endPoint = [[onePoint lastObject] CGPointValue];
        [self drawContentPointWithPoint:startPoint LayerNumber:i];
        if (i+1 == self.BeginPoints.count)
        {
            [self drawContentPointWithPoint:endPoint LayerNumber:i+1];
        }
    }
}

- (void)drawContentPointWithPoint:(CGPoint)point LayerNumber:(int)num
{
    CALayer *setPoint = [[ZJLineChartShapeLayer sharedLineChartShapeLayer]
                         drawBezierRoundWithPoint:CGPointMake(point.x-6,point.y-6)
                         Size:CGSizeMake(10, 10)
                         LineWidth:1
                         LineColor:[UIColor whiteColor]
                         BackGroundColor:[UIColor colorWithRed:0.1333 green:0.4824 blue:0.251 alpha:1.0]
                         cornerRadius:5];
    [setPoint setValue:[NSString stringWithFormat:@"pointSet_%d",num] forKey:SuberLayerNameKey];
    [self.layer addSublayer:setPoint];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    for (int i = 0; i < self.AimsPoints.count; i++)
    {
        NSArray *content = self.AimsPoints[i];
        CGPoint startPoint = [[content firstObject] CGPointValue];
        if (touchPoint.x > startPoint.x-m_AsixXWidht/2 && touchPoint.x < startPoint.x+m_AsixXWidht/2 &&
            touchPoint.y > startPoint.y-m_AsixYHeight/2 && touchPoint.y < startPoint.y+m_AsixYHeight/2)
        {
            [self changePointFillColorWithNumber:i Point:startPoint];
            break;
        }
        if (i+1 == self.AimsPoints.count)
        {
            CGPoint endPoint = [[content lastObject] CGPointValue];
            if (touchPoint.x > endPoint.x-m_AsixXWidht/2 && touchPoint.x < endPoint.x+m_AsixXWidht/2 &&
                touchPoint.y > endPoint.y-m_AsixYHeight/2 && touchPoint.y < endPoint.y+m_AsixYHeight/2)
            {
                [self changePointFillColorWithNumber:i+1 Point:endPoint];
                break;
            }
        }
    }
}

- (void)changePointFillColorWithNumber:(int)num Point:(CGPoint)point
{
    for (CALayer *obj in self.layer.sublayers)
    {
        if ([[obj valueForKey:SuberLayerNameKey] isEqualToString:[NSString stringWithFormat:@"pointSet_%d",num]])
        {
            ((CAShapeLayer *)obj).fillColor = [UIColor redColor].CGColor;
            if (self.block)
            {
                self.block(self.pointSet[num], point);
            }
        }
        else if ([[obj valueForKey:SuberLayerNameKey] rangeOfString:@"pointSet_"].location != NSNotFound &&
                 [[obj valueForKey:SuberLayerNameKey] rangeOfString:@"pointSet_"].length > 0)
        {
            ((CAShapeLayer *)obj).fillColor = [UIColor colorWithRed:0.1333 green:0.4824 blue:0.251 alpha:1.0].CGColor;
        }
    }
}

@end
