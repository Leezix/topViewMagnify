//
//  ViewController.m
//  ZXTopViewMagnify
//
//  Created by lzx on 17/3/20.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
#import "ZXSugarCode.h"

CGFloat const headerHeight = 200;
NSString *const cellID = @"cellID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UIView *headerView;
@property(nonatomic, weak) UIImageView *imgView;

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
    UIImageView *gbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"708d0ef7f8fdf69b56af65c4ba23587c.jpg"]];
    gbView.frame = view.frame;
    [view addSubview:gbView];
    
    self.headerView = view;
    self.imgView = gbView;
    
    //更换fillMode, 以实现放大=.=
    gbView.contentMode = UIViewContentModeScaleAspectFill;
    gbView.clipsToBounds = YES;
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

#pragma mark tableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

#pragma mark tableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat alpha =  1 - offset/136.0;
    if (offset > 0) {
        //平移
        self.imgView.zx_height = headerHeight;
        self.headerView.zx_height = headerHeight;
        self.headerView.zx_y = -offset;
        //有64-200的距离可动, 也就是0~136, alpha:1~0
        
        self.headerView.alpha = alpha <= 0? 0: alpha;
        
        //移至200 - 20+44的位置.停止移动.并显示导航栏.
        if(offset >= 136){
            [self.navigationController setNavigationBarHidden:NO];
        } else {
            [self.navigationController setNavigationBarHidden:YES];
        }
    } else {
        //放大
        self.headerView.zx_y = 0;
        self.headerView.alpha = 1;
        self.headerView.zx_height = -offset + headerHeight;
        self.imgView.zx_height = self.headerView.zx_height;
    }
    
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
