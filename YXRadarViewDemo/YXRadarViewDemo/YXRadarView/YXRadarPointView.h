//
//  YXRadarPointView.h
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXRadarPointViewDelegate;

@interface YXRadarPointView : UIView

@property(nonatomic,weak) id <YXRadarPointViewDelegate> delegate;

@end

@protocol YXRadarPointViewDelegate <NSObject>

@optional
- (void)didSelectItemRadarPointView:(nonnull YXRadarPointView *)radarPointView;   // 点击事件

@end
