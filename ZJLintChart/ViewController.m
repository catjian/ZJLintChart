//
//  ViewController.m
//  ZJLintChart
//
//  Created by jian zhang on 16/7/29.
//  Copyright © 2016年 jian zhang. All rights reserved.
//

#import "ViewController.h"
#import "ZJLineChartPlug/ZJLineChartPlug.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZJLineChartPlug *chartView = [[ZJLineChartPlug alloc] initWithFrame:CGRectMake(10, 200, 300, 300)];
    [chartView setBackgroundColor:[UIColor colorWithRed:0.1333 green:0.4824 blue:0.2588 alpha:1.0]];
    [chartView setDataX:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
    [chartView setDataY:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
    [chartView setPointSet:@[@[@"1",@"2"],@[@"2",@"6"],@[@"3",@"3"],@[@"4",@"4"],@[@"5",@"1"],@[@"6",@"7"]]];
    [self.view addSubview:chartView];
}

@end
