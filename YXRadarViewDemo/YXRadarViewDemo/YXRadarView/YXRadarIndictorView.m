//
//  YXRadarIndictorView.m
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXRadarIndictorView.h"

#define RADAR_DEFAULT_RADIUS 100.f
#define INDICATOR_START_COLOR [UIColor colorWithRed:8.0/255.0 green:242.0/255.0 blue: 46.0/255.0 alpha:1]
#define INDICATOR_END_COLOR [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue: 250.0/255.0 alpha:0]
#define INDICATOR_ANGLE 90.f
#define INDICATOR_CLOCKWISE YES

@implementation YXRadarIndictorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat defaultRadius = RADAR_DEFAULT_RADIUS;
    if (self.radius) {
        defaultRadius = self.radius;
    }
    UIColor *defaultStartColor = INDICATOR_START_COLOR;
    if (self.startColor) {
        defaultStartColor = self.startColor;
    }
    UIColor *defaultEndColor = INDICATOR_END_COLOR;
    if (self.endColor) {
        defaultEndColor = self.endColor;
    }
    CGFloat defaultAngle = INDICATOR_ANGLE;
    if (self.angle) {
        defaultAngle = self.angle;
    }
    BOOL defaultClockwise = self.clockwise;
    
    // 画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画扇形
    UIColor *startColor = defaultStartColor;
    CGContextSetFillColorWithColor(context, startColor.CGColor); // 填充颜色
    CGContextSetLineWidth(context, 0);  // 线宽
    CGContextMoveToPoint(context, rect.size.width*0.5, rect.size.height*0.5); // 圆心
    CGContextAddArc(context, rect.size.width*0.5, rect.size.height*0.5, defaultRadius, (defaultRadius?defaultAngle:0) * M_PI / 180, (defaultClockwise?(defaultAngle-1):1) * M_PI / 180, defaultRadius);  // 半径为 self.radius
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);  // 绘制
    
    const CGFloat *startColorComponents = CGColorGetComponents(defaultStartColor.CGColor);    //开始颜色的 RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(defaultEndColor.CGColor);    //结束颜色的 RGB components
    
    CGFloat R, G, B, A;
    for (int i = 0; i <= defaultAngle; i++)
    {
        CGFloat ratio = (defaultClockwise?(defaultAngle - i):i)/defaultAngle*1.0;
        R = startColorComponents[0] - (startColorComponents[0] - endColorComponents[0]) * ratio;
        G = startColorComponents[1] - (startColorComponents[1] - endColorComponents[1]) * ratio;
        B = startColorComponents[2] - (startColorComponents[2] - endColorComponents[2]) * ratio;
        A = startColorComponents[3] - (startColorComponents[3] - endColorComponents[3]) * ratio;
        
        UIColor *startColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
        
        CGContextSetFillColorWithColor(context, startColor.CGColor);
        CGContextSetLineWidth(context, 0);
        CGContextMoveToPoint(context, rect.size.width*0.5, rect.size.height*0.5);
        CGContextAddArc(context, rect.size.width*0.5, rect.size.height*0.5, defaultRadius, i * M_PI / 180, (i + (defaultClockwise?-1:1)) * M_PI / 180, defaultClockwise);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
