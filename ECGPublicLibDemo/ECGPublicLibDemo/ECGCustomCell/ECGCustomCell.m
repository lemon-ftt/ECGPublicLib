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
#import "ECGLayoutConstraint.h"


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
    __weak typeof(self) weakSelf = self;
    //头像
    [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([weakSelf handleLayout:20]);
        make.top.mas_equalTo([weakSelf handleLayout:20]);
        make.width.height.mas_equalTo([weakSelf handleLayout:120]);
    }];
    //用户名
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userPhoto.mas_right).offset([weakSelf handleLayout:10]);
        make.width.offset([weakSelf handleLayout:200]);
        make.centerY.equalTo(_userPhoto.mas_centerY);
        make.height.mas_equalTo([weakSelf handleLayout:40]);
    }];
    //自我介绍
    [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([weakSelf handleLayout:20]);
        make.right.equalTo(_introductionLabel.superview.mas_right).offset(-[weakSelf handleLayout:20]);
        make.top.equalTo(_userPhoto.mas_bottom).offset([weakSelf handleLayout:20]);
        make.bottom.equalTo(_introductionLabel.superview.mas_bottom).offset(-[weakSelf handleLayout:10]);
    }];
    
    self.nameLabel.text = _ECGModel.name;
    self.introductionLabel.text = _ECGModel.introduction;
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:_ECGModel.imgName] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
}

/**
 处理多屏幕显示
 
 @param value <#value description#>
 @return <#return value description#>
 */
- (CGFloat)handleLayout:(CGFloat)value {
    return [ECGLayoutConstraint getConstrainlWithValueFrom6:value];
}

@end
