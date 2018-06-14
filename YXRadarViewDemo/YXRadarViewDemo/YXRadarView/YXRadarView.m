//
//  YXRadarView.m
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "YXRadarView.h"
#import "YXRadarIndictorView.h"


#define RADAR_DEFAULT_SECTIONS_NUM 3
#define RADAR_ROTATE_SPEED 60.f
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

@implementation YXRadarView

static NSString * const rotationAnimationKey = @"rotationAnimation";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    if (!self.indicatorView) {
        YXRadarIndictorView *indicatorView = [[YXRadarIndictorView alloc] initWithFrame:self.bounds];
        [self addSubview:indicatorView];
        self.indicatorView = indicatorView;
    }
    
    if(!self.pointsView) {
        UIView *pointsView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:pointsView];
        self.pointsView = pointsView;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 画布
    CGContextRef context =  UIGraphicsGetCurrentContext();
    // 背景图片
    if (self.backgroundImage) {
        UIImage *image = self.backgroundImage;
        [image drawInRect:self.bounds]; // 画出图片
    }
    
    NSInteger sectionsNum = RADAR_DEFAULT_SECTIONS_NUM;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInRadarView:)]) {
        sectionsNum = [self.dataSource numberOfSectionsInRadarView:self];
    }
    
    CGFloat radius = rect.size.width*0.5;
    if (self.radius) {
        radius = _radius;
        self.indicatorView.radius = _radius;
    }

    if (self.indicatorAngle) {
        self.indicatorView.angle = _indicatorAngle;
    }

    
    self.indicatorView.clockwise = _indicatorClockwise;
    

    if (self.indicatorStartColor) {
        self.indicatorView.startColor = _indicatorStartColor;
    }

    if (self.indicatorEndColor) {
        self.indicatorView.endColor = _indicatorEndColor;
    }
    
    // 画图坐标轴
    CGContextMoveToPoint(context, 0, self.bounds.size.height * 0.5);
    CGContextSetRGBStrokeColor(context, 8.0/255, 242.0/255, 46.0/255, 1); //
    CGContextSetLineWidth(context, 1.0);    // 线宽
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height * 0.5);
    CGContextMoveToPoint(context, self.bounds.size.width * 0.5, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width * 0.5, self.bounds.size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat sectionRadius = radius / sectionsNum;
    for (int i = 0; i < sectionsNum; i++) {
        // 画圈
        CGContextSetLineWidth(context, 1.0);    // 线宽
        CGContextAddArc(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, sectionRadius - 5 * (sectionsNum - i - 1), 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        sectionRadius += radius / sectionsNum;
    }
    
}

#pragma mark - Actions
- (void)scan
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    BOOL indicatorClockwise = 0;
    indicatorClockwise = self.indicatorClockwise;
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:(indicatorClockwise?1:-1) * M_PI * 2.0];
    rotationAnimation.duration = 360.f / RADAR_ROTATE_SPEED;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [self.indicatorView.layer addAnimation:rotationAnimation forKey:rotationAnimationKey];
}

- (void)stop
{
    [self.indicatorView.layer removeAnimationForKey:rotationAnimationKey];
}

- (void)show
{
    for (UIView *subView in self.pointsView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPointsInRadarView:)]) {
        NSUInteger pointsNum = [self.dataSource numberOfPointsInRadarView:self];
        for (int index = 0; index < pointsNum; index++) {
            if (self.dataSource &&
                [self.dataSource respondsToSelector:@selector(radarView:viewForIndex:)] &&
                [self.dataSource respondsToSelector:@selector(radarView:positionForIndex:)]){
                
                CGPoint point = [self.dataSource radarView:self positionForIndex:index];
                int posDirection = point.x;     // 方向（角度）
                int posDistance = point.y;      // 距离(半径)
                
                YXRadarPointView *pointView = [[YXRadarPointView alloc] initWithFrame:CGRectZero];
                UIView *customView = [self.dataSource radarView:self viewForIndex:index];
                [pointView addSubview:customView];
                pointView.tag = index;
                pointView.frame = customView.frame;
                pointView.center = CGPointMake(self.frame.size.width*0.5 + posDistance*sin(DEGREES_TO_RADIANS(posDirection)), self.frame.size.height*0.5 + posDistance * cos(DEGREES_TO_RADIANS(posDirection)));
                pointView.delegate = self;
                
                // 动画
                pointView.alpha = 0.0;
                CGAffineTransform fromTransform = CGAffineTransformScale(pointView.transform, 0.1, 0.1);
                [pointView setTransform:fromTransform];
                
                CGAffineTransform toTransform = CGAffineTransformConcat(pointView.transform, CGAffineTransformInvert(pointView.transform));
                
                double delayInSeconds = 0.1 * index;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.5];
                    pointView.alpha = 1.0;
                    [pointView setTransform:toTransform];
                    [UIView commitAnimations];
                });
                
                [self.pointsView addSubview:pointView];
            }
        }
    }
}

- (void)hide
{
    
}

#pragma mark - YXRadarPointViewDelegate

- (void)didSelectItemRadarPointView:(YXRadarPointView *)radarPointView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(radarView:didSelectItemAtIndex:)]) {
        [self.delegate radarView:self didSelectItemAtIndex:radarPointView.tag];
    }
}


@end
