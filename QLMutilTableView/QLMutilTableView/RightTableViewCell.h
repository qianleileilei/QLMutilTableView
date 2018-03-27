//
//  RightTableViewCell.h
//  QLMutilTableView
//
//  Created by qianlei on 2018/3/27.
//  Copyright © 2018年 qianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTableViewCell : UITableViewCell

/**
 * 设置cell的数据显示
 *
 * @prama dataArray 数据元素
 *
 */
- (void)configCellDataWithArray:(NSArray *)dataArray;

@end
