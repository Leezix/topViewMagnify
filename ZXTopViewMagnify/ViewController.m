//
//  ViewController.m
//  ZXTopViewMagnify
//
//  Created by lzx on 17/3/20.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
#import "HMObjcSugar.h"

CGFloat const headerHeight = 200;
NSString *const cellID = @"cellID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    
    [self prepareTabelView];
    
    [self prepareHeader];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)prepareHeader{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.hm_width, headerHeight)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

- (void)prepareTabelView{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:table];
    
    //修改Inset
    table.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
    table.scrollIndicatorInsets = table.contentInset;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
