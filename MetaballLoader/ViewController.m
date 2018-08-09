//
//  ViewController.m
//  MetaballLoader
//
//  Created by sulink on 2018/8/9.
//  Copyright © 2018年 深圳数联通. All rights reserved.
//

#import "ViewController.h"
#import "MetaSpin.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MetaSpin *metaSpin = [[MetaSpin alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    metaSpin.center = self.view.center;
    metaSpin.ballFillColor = [UIColor lightGrayColor];
    metaSpin.centralBallRadius = 50.0;
    metaSpin.sideBallRadius = 15.0;
    
    [self.view addSubview:metaSpin];
    //开始动画
    [metaSpin animateSideBall];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
