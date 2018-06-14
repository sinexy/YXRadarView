//
//  YXRadarView.h
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXRadarPointView.h"

@class YXRadarIndictorView;

@protocol YXRadarViewDelegate;
@protocol YXRadarViewDateSource;

@interface YXRadarView : UIView<YXRadarPointViewDelegate>

@property (nonatomic, assign) CGFloat radius;   // 半径
@property (nonatomic, assign) NSInteger sectionsNum; // 环数
@property(nullable, nonatomic,strong) UIColor *indicatorStartColor; // 开始颜色
@property(nullable, nonatomic,strong) UIColor *indicatorEndColor;   // 结束颜色
@property (nonatomic, assign) CGFloat indicatorAngle;   // 扇形角度
@property (nonatomic, assign) BOOL indicatorClockwise;  // 是否顺时针
@property(nullable, nonatomic,strong) UIImage *backgroundImage; // 背景图片
@property(nullable, nonatomic,strong) UIView *pointsView;   // 目标点视图
@property(nullable, nonatomic,strong) YXRadarIndictorView *indicatorView;   // 扫描指针

@property(nullable, nonatomic,weak) id<YXRadarViewDateSource> dataSource;   // 数据源
@property(nullable, nonatomic,weak) id<YXRadarViewDelegate> delegate;   // 委托

- (void)scan;   // 扫描
- (void)stop;   // 停止
- (void)show;   // 显示目标
- (void)hide;   // 隐藏目标

@end

@protocol YXRadarViewDateSource <NSObject>  // 数据源

@optional

- (NSInteger)numberOfSectionsInRadarView:(nullable YXRadarView *)radarView;
- (NSInteger)numberOfPointsInRadarView:(nullable YXRadarView *)radarView;
- (nonnull UIView *)radarView:(nullable YXRadarView *)radarView viewForIndex:(NSUInteger)index; //  自定义目标点视图
- (CGPoint)radarView:(nullable YXRadarView *)radarView positionForIndex:(NSUInteger)index;  // 目标点所在位置

@end

@protocol YXRadarViewDelegate <NSObject>

@optional

- (void)radarView:(nullable YXRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index;  // 点击事件

@end
