//
//  QLMutilTableView.h
//  QLMutilTableView
//
//  Created by qianlei on 2018/3/27.
//  Copyright © 2018年 qianlei. All rights reserved.
//  一个用于实现左右两张表滑动的控件

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TableType) {
    /** 左边表格 */
    MutilLeftTable = 1,
    /** 右边表格 */
    MutilRightTable
};


@protocol MutilTableTitleEventDelegate <NSObject>

/**
 * 点击了右表表头的回掉方法
 *
 * @prama titleIndex 标识当前被点击列的index
 *
 */
- (void)didSelectRightTableTitleForIndex:(NSInteger)titleIndex;

/**
 * 点击了左表的表头的回掉方法
 */
- (void)didSelectLeftTitle;

@end


@protocol MutilTableViewDelegate <NSObject>

/**
 * 组合表格的单元格cell的点击事件
 */
- (void)didSelectMutilTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

/**
 * 组合表格的cell行数
 */
- (NSInteger)mutilTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 * 组合表格的单元格cell的数据源显示回掉
 */
- (UITableViewCell *)mutilTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 * 实时滑动事件回调
 */
- (void)mutilTableViewDidScroll:(CGFloat)offsetX;

@end

@interface QLMutilTableView : UIView

/** 表头标题文案的颜色 */
@property (nonatomic, strong) UIColor *titleTextColor;

/** 右表标题的对齐方式 */
@property (nonatomic, assign) NSTextAlignment alignment;

/** 表头标题部分的字体大小 */
@property (nonatomic, strong) UIFont *titleTextFont;

/** 表头标题的高度 */
@property (nonatomic, assign) CGFloat titleheight;

/** 设置cell的行高 */
@property (nonatomic, assign) CGFloat mutilRowHeight;

/** 是否显示可向左滑动的提示箭头 */
@property (nonatomic, assign) BOOL showArrow;

/** 是否支持表头点击操作 */
@property (nonatomic, assign) BOOL supportTitleClicked;

/** 组合表格表头事件的代理 */
@property (nonatomic, weak) id<MutilTableTitleEventDelegate> sortDelegate;

/** 组合表格的代理 */
@property (nonatomic, weak) id<MutilTableViewDelegate> delegate;

/** 设置左边表格的标题 */
@property (nonatomic, copy) NSString *leftTitleString;

/** 设置右边表格的标题 */
@property (nonatomic, copy) NSArray *headList;

/** 多表的背景颜色 */
@property (nonatomic, strong) UIColor *mutilBackGroundColor;

/** 多表表头的背景颜色 */
@property (nonatomic, strong) UIColor *mutilTitleBackGroundColor;

/** 是否支持表格的上下滑动 */
@property (nonatomic, assign) BOOL verticalScrollEnable;

/**
 * 表格的初始化方法，需要传入部分参数，已确定子控件的显示比例
 *
 * @prama frame 整个控件的frame大小
 *
 * @prama titleSize 左边表格标题的size，可以确定左表固定列的宽度，以及表头的高度
 *
 * @prama contentSize 右边的内容size，用以确定右表的宽度和高度
 *
 */
- (instancetype)initWithFrame:(CGRect)frame leftTitleSize:(CGSize)titleSize rightTableContentSize:(CGSize)contentSize;

/**
 * 组合表格重新加载刷新数据
 */
- (void)reloadData;

@end
