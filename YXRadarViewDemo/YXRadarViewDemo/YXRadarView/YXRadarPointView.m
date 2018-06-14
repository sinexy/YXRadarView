//
//  YXRadarPointView.m
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//


#import "YXRadarPointView.h"
#define ANIMATIONWIDTH 10
#define ANIMATIONDURATION 1

@interface YXRadarPointView (){
    CAAnimationGroup    *_animationGroup;
    CADisplayLink       *_disPlayLink;
    CALayer             *_layer;
}

@end

@implementation YXRadarPointView

#pragma mark - select point

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemRadarPointView:)]) {
            [self.delegate didSelectItemRadarPointView:self];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self start];
    }
    return self;
}

- (void)start
{
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAnimation)];
    _disPlayLink.frameInterval = 60;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopAgin:(BOOL)stop
{
    _disPlayLink.paused = stop;
}

- (void)startAnimation
{
    
    _layer = [CALayer layer];
    _layer.cornerRadius = ANIMATIONWIDTH / 2;
    _layer.frame = CGRectMake(-self.frame.size.width*0.5, -self.frame.size.height*0.5, ANIMATIONWIDTH, ANIMATIONWIDTH);
    _layer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_layer];
    
    
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    _animationGroup = [CAAnimationGroup animation];
    _animationGroup.duration = ANIMATIONDURATION;
    _animationGroup.removedOnCompletion = YES;
    _animationGroup.timingFunction = linearCurve;
    
    CABasicAnimation *scaleAniamtion = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAniamtion.fromValue = @0.1;
    scaleAniamtion.toValue = @2.0;
    scaleAniamtion.duration = ANIMATIONDURATION;
    
    CAKeyframeAnimation *opencityAniamtion = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAniamtion.duration = ANIMATIONDURATION;
    opencityAniamtion.values = @[@0.08, @1, @0.0];
    opencityAniamtion.keyTimes = @[@0, @0.5, @1];
    opencityAniamtion.removedOnCompletion = YES;
    
    NSArray *animations = @[scaleAniamtion, opencityAniamtion];
    _animationGroup.animations = animations;
    [_layer addAnimation:_animationGroup forKey:nil];
    
    [self performSelector:@selector(removeLayer:) withObject:_layer afterDelay:0.9];
    
}

- (void)removeLayer:(CALayer *)layer
{
    [layer removeFromSuperlayer];
}

@end
