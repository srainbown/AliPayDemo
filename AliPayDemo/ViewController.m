//
//  ViewController.m
//  AliPayDemo
//
//  Created by guoyutao on 2017/6/26.
//  Copyright © 2017年 guoyutao. All rights reserved.
//

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define functionHeaderViewHeight 200

#import "ViewController.h"
#import "UIButton+Align.h"
#import "IndexTableView.h"
#import <MJRefresh/MJRefresh.h>


@interface ViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) IndexTableView *mainTableView;
@property (nonatomic,assign) CGFloat topOffsetY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topOffsetY = functionHeaderViewHeight;
    
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.navView];
    

    [self.mainScrollView addSubview:self.headerView];
    [self.mainScrollView addSubview:self.mainTableView];
    
    __weak ViewController *weakSelf = self;
    _mainTableView.changeContentSize = ^(CGSize contentSize) {
        [weakSelf updateContentSize:contentSize];
    };
    
//    weakSelf.mainScrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mainTableView reloadData];
    [self updateContentSize:self.mainTableView.contentSize];
}

- (void)updateContentSize:(CGSize)size {
    
    CGSize contentSize = size;
    contentSize.height = contentSize.height + _topOffsetY;
    _mainScrollView.contentSize = contentSize;
    
    CGRect newframe = _mainTableView.frame;
    newframe.size.height = size.height;
    _mainTableView.frame = newframe;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",y);
    
    if (y <= 0) {
        
        CGRect newFrame = self.headerView.frame;
        newFrame.origin.y = y;
        self.headerView.frame = newFrame;
        
        newFrame = self.mainTableView.frame;
        newFrame.origin.y = y + _topOffsetY;
        self.mainTableView.frame = newFrame;
        
        //偏移量给到tableview，tableview自己来滑动
        [self.mainTableView setScrollViewContentOffSetWithPoint:CGPointMake(0, y)];
        

    }else if(y < functionHeaderViewHeight && y > 0) {

    }
}

#pragma mark - privite
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        _navView.backgroundColor = [UIColor colorWithRed:65/255.0 green:128/255.0 blue:255.0/255.0 alpha:1];
        _navView.backgroundColor = [UIColor blueColor];
    }
    return _navView;
}


//mainScrollView
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
        _mainScrollView.delegate = self;
//        _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _mainScrollView;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, functionHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor colorWithRed:65/255.0 green:128/255.0 blue:255.0/255.0 alpha:1];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

- (IndexTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[IndexTableView alloc]initWithFrame:CGRectMake(0, _topOffsetY, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _mainTableView.scrollEnabled = false;
        _mainTableView.bounces = false;
    }
    return _mainTableView;
}

- (void)refreshFooter{
    __block ViewController/*主控制器*/ *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.mainScrollView.mj_footer endRefreshing];
        [weakSelf.mainTableView loadMoreData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
