//
//  ECGCustomCell.m
//  ECGCustomCellDemo
//
//  Created by tan on 2017/3/6.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ECGCustomCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"



@implementation ECGCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _userPhoto = [[UIImageView alloc]init];
        _userPhoto.contentMode = UIViewContentModeScaleAspectFit;
//        _userPhoto.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_userPhoto];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        _nameLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_nameLabel];
        
        _introductionLabel = [[UILabel alloc]init];
        _introductionLabel.backgroundColor = [UIColor lightGrayColor];
        _introductionLabel.font = [UIFont systemFontOfSize:14.0];
        _introductionLabel.numberOfLines = 0;
        [self.contentView addSubview:_introductionLabel];
    }
    return self;
}

- (void) setECGModel:(ECGModel *)ECGModel {
    if (_ECGModel != ECGModel)
    {
        _ECGModel = ECGModel;
        [self layoutIfNeeded];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*
     *可以有部分控件高度不固定，
     *但是必须有一个控件撑起来cell，
     *比如userPhoto控件从顶部出发，自我介绍控件高度没写，顶部与头像控件底部关联，底部等于cell的底部
    */
    
    //头像
    [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(60);
    }];
    //用户名
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userPhoto.mas_right).offset(5);
        make.width.offset(100);
        make.centerY.equalTo(_userPhoto.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    //自我介绍
    [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(_introductionLabel.superview.mas_right).offset(-10);
        make.top.equalTo(_userPhoto.mas_bottom).offset(10);
        make.bottom.equalTo(_introductionLabel.superview.mas_bottom).offset(-5);
    }];
    
    self.nameLabel.text = _ECGModel.name;
    self.introductionLabel.text = _ECGModel.introduction;
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:_ECGModel.imgName] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
}

@end
