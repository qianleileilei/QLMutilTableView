//
//  QLMutilTableView.m
//  QLMutilTableView
//
//  Created by qianlei on 2018/3/27.
//  Copyright © 2018年 qianlei. All rights reserved.
//

#import "QLMutilTableView.h"

#define DefaultLeftTableWidth 90    //默认的左表宽度
#define DefaultTableTitleHeight 35    //默认的表头高度

@interface QLMutilTableView ()  <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *arrorImageView;  //右边标示可以滑动的箭头
@property (nonatomic, strong) UILabel *leftTitleLabel;  //左表表头标题的Label
@property (nonatomic, strong) UIScrollView *topicScrollView;    //可左右滑动的右部表头
@property (nonatomic, strong) UITableView *leftTableView;   //左边不能左右滑动的表格
@property (nonatomic, strong) UITableView *rightTableView;  //右边可以左右滑动的标题内容表格
@property (nonatomic, strong) UIScrollView *containerScrollView;    //底部容器ScrollView
@property (nonatomic, assign) CGFloat rightTableWidth;    //右边表格的宽度

@end

@implementation QLMutilTableView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.headList = [[NSMutableArray alloc] init];
        self.alignment = NSTextAlignmentCenter; //默认标题项居中
        self.supportTitleClicked = NO;  //默认不支持排序
        self.titleheight = DefaultTableTitleHeight;  //设置默认的行高
        self.leftTableWidth = DefaultLeftTableWidth;    //设置默认的左表宽度
        self.rightTableWidth = CGRectGetWidth(frame) - self.leftTableWidth;
        [self addSubview:self.leftTitleLabel];
        [self addSubview:self.topicScrollView];
        [self addSubview:self.containerScrollView];
        [self addSubview:self.leftTableView];
        [self.containerScrollView addSubview:self.rightTableView];
        [self configMutilTableSubViewFrameAndContentSize];
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //控制滚动条的正常显示，避免由于左右滑动表格时，滚动条无法正确显示的问题
    if (self.alignment == NSTextAlignmentRight) {   //右对齐时避免滚动条遮挡数据，把滚动条移除可视范围20个像素点
        self.rightTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.rightTableView.frame) - (self.containerScrollView.frame.size.width - self.leftTableView.frame.size.width + self.containerScrollView.bounds.origin.x) - 20);
    } else {    //让滚动条靠边显示
        self.rightTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, self.rightTableView.frame.size.width - (self.containerScrollView.frame.size.width - self.leftTableView.frame.size.width + self.containerScrollView.bounds.origin.x));
    }
    
    if (scrollView == self.leftTableView || scrollView == self.rightTableView) {
        //控制上下滑
        CGRect scrollBounds1 = self.leftTableView.bounds;
        scrollBounds1.origin.y = scrollView.contentOffset.y;
        self.leftTableView.bounds = scrollBounds1;
        CGRect scrollBounds2 = self.rightTableView.bounds;
        scrollBounds2.origin.y = scrollBounds1.origin.y;
        self.rightTableView.bounds = scrollBounds2;
    }
    if (scrollView == self.containerScrollView || scrollView == self.topicScrollView) {
        CGRect scrollBounds1 = self.containerScrollView.bounds;
        scrollBounds1.origin.x = scrollView.contentOffset.x;
        self.containerScrollView.bounds = scrollBounds1;
        CGRect scrollBounds2 = self.topicScrollView.bounds;
        scrollBounds2.origin.x = scrollView.contentOffset.x;
        self.topicScrollView.bounds = scrollBounds2;
        //控制箭头的显示
        if (self.showArrow == YES) {
            if (scrollView.contentOffset.x > 5) {
                self.arrorImageView.hidden = YES;
            } else {
                self.arrorImageView.hidden = NO;
            }
        }
        if (scrollView.contentOffset.x <= 0) {  //避免右边向左滑动时出现负偏移，导致表格整体出现撕裂的画面感
            CGRect scrollBounds1 = self.containerScrollView.bounds;
            scrollBounds1.origin.x = 0;
            self.containerScrollView.bounds = scrollBounds1;
            CGRect scrollBounds2 = self.topicScrollView.bounds;
            scrollBounds2.origin.x = 0;
            self.topicScrollView.bounds = scrollBounds2;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(mutilTableViewDidScroll:)]) {
            [_delegate mutilTableViewDidScroll:scrollView.contentOffset.x];
        }
    }
}

//滑动列表停止拖拽时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != nil && (scrollView == self.containerScrollView || scrollView == self.topicScrollView) && !decelerate) {
        [self correctColumnOffsetWhileScrollViewEndScroll:scrollView];
    }
}

//滑动列表减速到停止滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != nil && (scrollView == self.containerScrollView || scrollView == self.topicScrollView)) {
        [self correctColumnOffsetWhileScrollViewEndScroll:scrollView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_delegate mutilTableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_delegate mutilTableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate didSelectMutilTableView:tableView atIndexPath:indexPath];
}

//增加高亮选中效果
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *leftCell = [self.leftTableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *rightCell = [self.rightTableView cellForRowAtIndexPath:indexPath];
    [leftCell setHighlighted:YES];
    [rightCell setHighlighted:YES];
}

//取消高亮选中效果
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *leftCell = [self.leftTableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *rightCell = [self.rightTableView cellForRowAtIndexPath:indexPath];
    [leftCell setHighlighted:NO];
    [rightCell setHighlighted:NO];
}

#pragma mark - event response
- (void)buttonAction:(UIButton *)sender {
    if (self.supportTitleClicked == YES) {
        if (_sortDelegate && [_sortDelegate respondsToSelector:@selector(didSelectRightTableTitleForIndex:)]) {
            [_sortDelegate didSelectRightTableTitleForIndex:sender.tag];
        }
    } else {
        //不支持表头点击操作的表格，点击以后直接返回
        return;
    }
}

- (void)resignSortAction:(UITapGestureRecognizer *)recognizer {
    if (_sortDelegate && [_sortDelegate respondsToSelector:@selector(didSelectLeftTitle)]) {
        if (self.supportTitleClicked == YES) {
            [_sortDelegate didSelectLeftTitle];
        }
    }
}

#pragma mark - private method
//设置右表头的标题内容
- (void)setRightTableViewTopics:(NSArray *)headList {
    if(headList && [headList count] > 0) {
        for (int i = 0; i < [headList count]; i++) {
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            titleBtn.frame = CGRectMake(self.rightColumnWidth * i, 0, self.rightColumnWidth, self.titleheight);
            [titleBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (self.titleTextFont) {
                titleBtn.titleLabel.font = self.titleTextFont;
            } else {
                titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            }
            if (self.titleTextColor) {
                [titleBtn setTitleColor:self.titleTextColor forState:UIControlStateNormal];
            } else {
                [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            titleBtn.backgroundColor = [UIColor clearColor];
            if (self.alignment == NSTextAlignmentRight) {
                titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            } else if (self.alignment == NSTextAlignmentLeft) {
                titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            } else if (self.alignment == NSTextAlignmentCenter) {
                titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            } else {
                titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            }
            titleBtn.tag = i + 1;
            [titleBtn setTitle:[NSString stringWithFormat:@"%@", [headList objectAtIndex:i]] forState:UIControlStateNormal];
            [self.topicScrollView addSubview:titleBtn];
        }
    }
}

//设置多表控件内部滚动视图的布局与contentSize
- (void)configMutilTableSubViewFrameAndContentSize {
    self.leftTitleLabel.frame = CGRectMake(0, 0, self.leftTableWidth, self.titleheight);
    self.topicScrollView.frame = CGRectMake(self.leftTableWidth, 0, CGRectGetWidth(self.frame) - self.leftTableWidth, self.titleheight);
    self.containerScrollView.frame = CGRectMake(0, self.titleheight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.titleheight);
    self.leftTableView.frame = CGRectMake(0, self.titleheight, self.leftTableWidth, CGRectGetHeight(self.frame) - self.titleheight);
    self.rightTableView.frame = CGRectMake(self.leftTableWidth, 0, self.rightTableWidth, CGRectGetHeight(self.containerScrollView.frame));
    [self.rightTableView setContentSize:CGSizeMake(self.rightTableWidth, CGRectGetHeight(self.frame))];
    self.containerScrollView.contentSize = CGSizeMake(self.leftTableWidth + self.rightTableWidth, 1);
    self.topicScrollView.contentSize = CGSizeMake(self.rightTableWidth, self.titleheight);
}

//控制当滑动停止时某一项数据显示不全时，左右自动偏移让当前数据项显示完整
- (void)correctColumnOffsetWhileScrollViewEndScroll:(UIScrollView *)scrollView {
    float offsetx = scrollView.contentOffset.x;
    int nDiff = 0;
    int nSign = 1;
    if(offsetx + scrollView.frame.size.width >= scrollView.contentSize.width) {
        nDiff = 0;
    } else {
        if(offsetx >= self.rightColumnWidth) {
            nDiff = (int)(offsetx) % (int)self.rightColumnWidth;
            if(nDiff > (self.rightColumnWidth / 2)) {
                nDiff = self.rightColumnWidth - nDiff;
                nSign = -1;
            }
        } else {
            nDiff = (int)offsetx;
            if(nDiff > (self.rightColumnWidth / 2)) {
                nDiff = self.rightColumnWidth - nDiff;
                nSign = -1;
            }
        }
    }
    if(nDiff != 0) {
        float ff = scrollView.contentOffset.x;
        ff -= (nDiff * nSign);
        CGRect vr = CGRectMake(ff, scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:vr animated:YES];
        return;
    }
}

- (void)reloadData {
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

#pragma mark - setter and getter
- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.userInteractionEnabled = YES;
        if (self.titleTextFont) {
            _leftTitleLabel.font = self.titleTextFont;
        } else {
            _leftTitleLabel.font = [UIFont systemFontOfSize:14.0];
        }
        if (self.titleTextColor) {
            _leftTitleLabel.textColor = self.titleTextColor;
        } else {
            _leftTitleLabel.textColor = [UIColor blackColor];
        }
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        //添加单击手势，用于处理表头事件回掉
        UITapGestureRecognizer *tapTitleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignSortAction:)];
        tapTitleRecognizer.numberOfTapsRequired = 1;
        [_leftTitleLabel addGestureRecognizer:tapTitleRecognizer];
    }
    
    return _leftTitleLabel;
}

- (UIScrollView *)topicScrollView {
    if (!_topicScrollView) {
        _topicScrollView = [[UIScrollView alloc] init];
        _topicScrollView.alwaysBounceHorizontal = YES;
        _topicScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;//顶部的表头，只要保证宽度自适应
        _topicScrollView.scrollEnabled = YES;
        _topicScrollView.showsHorizontalScrollIndicator = NO;
        _topicScrollView.delegate = self;
    }
    
    return _topicScrollView;
}

- (UIScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.backgroundColor = [UIColor whiteColor];
        _containerScrollView.delegate =self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.showsHorizontalScrollIndicator = NO;
        _containerScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    return _containerScrollView;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleheight, self.leftTableWidth, CGRectGetHeight(self.frame) - self.titleheight) style:UITableViewStylePlain];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tag = MutilLeftTable;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    }
    
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.leftTableWidth, 0, self.rightTableWidth, CGRectGetHeight(self.containerScrollView.frame)) style:UITableViewStylePlain];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.tag = MutilRightTable;
        _rightTableView.showsVerticalScrollIndicator = YES;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    return _rightTableView;
}

- (UIImageView *)arrorImageView {
    if (!_arrorImageView) {
        _arrorImageView = [[UIImageView alloc] init];
        _arrorImageView.image = [UIImage imageNamed:@"arrow"];
    }
    
    return _arrorImageView;
}

- (void)setLeftTableWidth:(CGFloat)leftTableWidth {
    _leftTableWidth = leftTableWidth;
    if (self.headList.count > 0) {  //当右边列存在数据时，才对列表布局进行跟新，否则只是记录当前的左边宽度
        [self configMutilTableSubViewFrameAndContentSize];  //根据左侧的宽度重新设置视图的布局
    }
}

- (void)setRightColumnWidth:(CGFloat)rightColumnWidth {
    _rightColumnWidth = rightColumnWidth;
    if (self.headList.count > 0) {  //当右边列存在数据时，才对列表布局进行跟新，否则只是记录当前的右边宽度
        self.rightTableWidth = _rightColumnWidth * self.headList.count;
        [self configMutilTableSubViewFrameAndContentSize];  //根据左侧的宽度重新设置视图的布局
        [self setRightTableViewTopics:self.headList];
    }
}

- (void)setMutilRowHeight:(CGFloat)mutilRowHeight {
    _mutilRowHeight = mutilRowHeight;
    self.leftTableView.rowHeight = _mutilRowHeight;
    self.rightTableView.rowHeight = _mutilRowHeight;
}

- (void)setShowArrow:(BOOL)showArrow {
    if (_showArrow != showArrow) {
        _showArrow = showArrow;
        if (_showArrow == YES) {
            self.arrorImageView.frame = CGRectMake(CGRectGetWidth(self.topicScrollView.frame) - 10, (CGRectGetHeight(self.topicScrollView.frame) - 12) / 2, 6, 12);
            [self.topicScrollView addSubview:self.arrorImageView];
        }
    }
}

- (void)setLeftTitleString:(NSString *)leftTitleString {
    if (_leftTitleString != leftTitleString) {
        _leftTitleString = leftTitleString;
        _leftTitleLabel.text = _leftTitleString;
        if (self.titleTextFont) {
            _leftTitleLabel.font = self.titleTextFont;
        } else {
            _leftTitleLabel.font = [UIFont systemFontOfSize:14.0];
        }
        if (self.titleTextColor) {
            _leftTitleLabel.textColor = self.titleTextColor;
        } else {
            _leftTitleLabel.textColor = [UIColor blackColor];
        }
    }
}

- (void)setHeadList:(NSArray *)headList {
    _headList = [headList copy];
    if (_headList.count > 0 && self.rightColumnWidth > 0) {  //当右边列存在数据时，才对列表布局进行跟新
        self.rightTableWidth = self.rightColumnWidth * self.headList.count;
        [self configMutilTableSubViewFrameAndContentSize];  //根据左侧的宽度重新设置视图的布局
        [self setRightTableViewTopics:self.headList];
    }
}

- (void)setMutilBackGroundColor:(UIColor *)mutilBackGroundColor {
    self.backgroundColor = mutilBackGroundColor;
    self.containerScrollView.backgroundColor = mutilBackGroundColor;
    self.leftTableView.backgroundColor = mutilBackGroundColor;
    self.rightTableView.backgroundColor = mutilBackGroundColor;
}

- (void)setMutilTitleBackGroundColor:(UIColor *)mutilTitleBackGroundColor {
    self.leftTitleLabel.backgroundColor = mutilTitleBackGroundColor;
    self.topicScrollView.backgroundColor = mutilTitleBackGroundColor;
}

- (void)setVerticalScrollEnable:(BOOL)verticalScrollEnable {
    self.leftTableView.scrollEnabled = verticalScrollEnable;
    self.rightTableView.scrollEnabled = verticalScrollEnable;
}

@end
