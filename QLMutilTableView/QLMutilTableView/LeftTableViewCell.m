//
//  LeftTableViewCell.m
//  QLMutilTableView
//
//  Created by qianlei on 2018/3/27.
//  Copyright © 2018年 qianlei. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftTableTextLabel;

@end


@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLeftTitleString:(NSString *)leftTitleString {
    if (_leftTitleString != leftTitleString) {
        _leftTitleString = leftTitleString;
        self.leftTableTextLabel.text = _leftTitleString;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
