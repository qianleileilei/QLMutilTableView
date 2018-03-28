//
//  ViewController.m
//  QLMutilTableView
//
//  Created by qianlei on 2018/3/27.
//  Copyright © 2018年 qianlei. All rights reserved.
//

#import "ViewController.h"
#import "QLMutilTableView.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"

#define NavigationBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)    //导航条的高度


@interface ViewController () <MutilTableTitleEventDelegate, MutilTableViewDelegate>

@property (nonatomic, strong) QLMutilTableView *mutilTableView; //多表控件

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"多表的使用";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mutilTableView];
}

#pragma mark - MutilTableTitleEventDelegate
//点击了右表表头的回掉方法
- (void)didSelectRightTableTitleForIndex:(NSInteger)titleIndex {
    NSLog(@"right title has clicked with index = %ld", titleIndex);
}

//点击了左表的表头的回掉方法
- (void)didSelectLeftTitle {
    NSLog(@"left title has clicked");
}

#pragma mark - MutilTableViewDelegate
- (void)mutilTableViewDidScroll:(CGFloat)offsetX {
//    NSLog(@"offsetX = %f", offsetX);
}

- (NSInteger)mutilTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)mutilTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *leftIdentifier = @"LeftTableCell";
    static NSString *rightIdentifier = @"TightTableCell";
    if(tableView.tag == MutilLeftTable) {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftIdentifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:leftIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:leftIdentifier];
        }
        cell.leftTitleString = [NSString stringWithFormat:@"行标:%ld", indexPath.row + 1];
        return cell;
    } else {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightIdentifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:rightIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:rightIdentifier];
        }
        NSMutableArray *dataArray = [NSMutableArray new];
        for (NSInteger i = 0; i < 10; i++) {
            [dataArray addObject:[NSString stringWithFormat:@"%u", (arc4random() % 10000) + 1]];
        }
        [cell configCellDataWithArray:dataArray];
        return cell;
    }
}

- (void)didSelectMutilTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"选中了%ld行", indexPath.row + 1] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setter and getter
- (QLMutilTableView *)mutilTableView {
    if (!_mutilTableView) {
        _mutilTableView = [[QLMutilTableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - NavigationBarHeight)];
        _mutilTableView.mutilBackGroundColor = [UIColor whiteColor];
        _mutilTableView.mutilTitleBackGroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0];
        _mutilTableView.titleTextColor = [UIColor blackColor];
        _mutilTableView.titleTextFont = [UIFont systemFontOfSize:15];
        _mutilTableView.mutilRowHeight = 50;
        _mutilTableView.leftTableWidth = 90;
        _mutilTableView.rightColumnWidth = 90;
        _mutilTableView.leftTitleString = @"固定列";
        _mutilTableView.headList = [NSArray arrayWithObjects:@"第一列", @"第二列", @"第三列", @"第四列", @"第五列", @"第六列", @"第七列", @"第八列", @"第九列", @"第十列", nil];
        _mutilTableView.showArrow = YES;
        _mutilTableView.supportTitleClicked = YES;
        _mutilTableView.delegate = self;
        _mutilTableView.sortDelegate = self;
        _mutilTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    }
    
    return _mutilTableView;
}

@end
