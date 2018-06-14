//
//  YXRadarIndictorView.h
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXRadarIndictorView : UIView

/**
 * 雷达指针
 * 弧形扫描扇叶的半径
 * 默认 100
 */
@property (nonatomic, assign) CGFloat radius;
/**
 * 雷达指针
 * 弧形扫描扇叶的开始颜色
 * 默认 RGBA(8,242,46,1)
 */
@property(nullable, nonatomic,strong) UIColor *startColor;
/**
 * 雷达指针
 * 弧形扫描扇叶的结束颜色
 * 默认 RGBA(0,0,0,0)
 */
@property(nullable, nonatomic,strong) UIColor *endColor;
/**
 * 雷达指针
 * 弧形扫描扇叶角度
 * 默认 90度 占1/4个圆
 */
@property (nonatomic, assign) CGFloat angle;
/**
 * 雷达指针
 * 弧形扫描扇叶拖尾方向
 * 默认 顺时针旋转
 */
@property (nonatomic, assign) BOOL clockwise;

@end
