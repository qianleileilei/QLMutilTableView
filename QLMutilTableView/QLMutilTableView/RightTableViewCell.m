//
//  RightTableViewCell.m
//  QLMutilTableView
//
//  Created by qianlei on 2018/3/27.
//  Copyright © 2018年 qianlei. All rights reserved.
//

#import "RightTableViewCell.h"

@interface RightTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *ontLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightLabel;
@property (weak, nonatomic) IBOutlet UILabel *nineLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenLabel;

@end

@implementation RightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//设置cell的数据显示
- (void)configCellDataWithArray:(NSArray *)dataArray {
    if (dataArray && dataArray.count >= 10) {
        self.ontLabel.text = [dataArray objectAtIndex:0];
        self.twoLabel.text = [dataArray objectAtIndex:1];
        self.threeLabel.text = [dataArray objectAtIndex:2];
        self.fourLabel.text = [dataArray objectAtIndex:3];
        self.fiveLabel.text = [dataArray objectAtIndex:4];
        self.sixLabel.text = [dataArray objectAtIndex:5];
        self.sevenLabel.text = [dataArray objectAtIndex:6];
        self.eightLabel.text = [dataArray objectAtIndex:7];
        self.nineLabel.text = [dataArray objectAtIndex:8];
        self.tenLabel.text = [dataArray objectAtIndex:9];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
