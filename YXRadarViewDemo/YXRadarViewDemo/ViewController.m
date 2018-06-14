//
//  ViewController.m
//  YXRadarViewDemo
//
//  Created by yunxin bai on 2018/6/14.
//  Copyright © 2018年 yunxin bai. All rights reserved.
//

#import "ViewController.h"
#import "YXRadarIndictorView.h"
#import "YXRadarView.h"

@interface ViewController ()<YXRadarViewDelegate, YXRadarViewDateSource>

@property (nonatomic, weak) YXRadarView *radarView;
@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ViewController

- (NSMutableArray *)pointsArray
{
    if (!_pointsArray) {
        _pointsArray = [NSMutableArray array];
    }
    return _pointsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupRadarView];
    
    self.textLabel = [UILabel new];
    self.textLabel.frame = CGRectMake(0, CGRectGetMaxY(self.radarView.frame) , self.view.frame.size.width, 30);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.text = @"正在搜索，请稍等.......";
    [self.view addSubview:self.textLabel];
    // 目标点位置
    [self randomPoints];
    [self.radarView scan];
    [self startUpdatingRadar];
}

- (void)setupRadarView
{
    YXRadarView *radarView = [[YXRadarView alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width-40, self.view.frame.size.width-40)];
    radarView.indicatorClockwise = YES;
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = (self.view.frame.size.width-40)*0.5;
    radarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [self.view addSubview:radarView];
    self.radarView = radarView;
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar
{
    // 模拟网络请求，加载数据3s后返回
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      typeof(self) __strong strongSelf = weakSelf;
        strongSelf.textLabel.text = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标",(unsigned long)strongSelf.pointsArray.count];
        [strongSelf.radarView show];
    });
}

- (void)randomPoints
{
    [self.pointsArray removeAllObjects];
    int x, y;
    for (int  i = 0; i < 10; i++) {
        x = arc4random_uniform((self.view.frame.size.width-40))-(self.view.frame.size.width-40)*0.5;
        y = arc4random_uniform((self.view.frame.size.width-40))-(self.view.frame.size.width-40)*0.5;
        [self.pointsArray addObject:@[@(x),@(y)]];
    }
}

- (void)flickAnimationForPoints
{
    static CGFloat opacityNum = 0;
    BOOL ascending = YES;
    if (ascending) {
        opacityNum += 0.1;
        if (opacityNum >= 1) {
            ascending = NO;
        }
    }else{
        opacityNum -= 0.1;
        if (opacityNum <= 0.2) {
            ascending = YES;
        }
    }
    NSLog(@"%@----",[NSThread currentThread]);
    self.layer.opacity = opacityNum;
    [self.layer setNeedsDisplay];
    NSLog(@"%@", self.layer);
}

#pragma mark - BYXRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(YXRadarView *)radarView
{
    return 4;
}

- (NSInteger)numberOfPointsInRadarView:(YXRadarView *)radarView
{
    return [self.pointsArray count];
}

- (UIView *)radarView:(YXRadarView *)radarView viewForIndex:(NSUInteger)index
{
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    pointView.backgroundColor = [UIColor redColor];
    pointView.layer.cornerRadius = 2.5f;
    return pointView;
}

- (CGPoint)radarView:(YXRadarView *)radarView positionForIndex:(NSUInteger)index
{
    NSArray *point = [self.pointsArray objectAtIndex:index];
    return CGPointMake([point[0] floatValue], [point[1] floatValue]);
}

#pragma mark - YXRadarViewDelegate

- (void)radarView:(YXRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"didSelectItemAtiIndex:%lu",(unsigned long)index] message:[NSString stringWithFormat:@"%@",self.pointsArray[index]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
