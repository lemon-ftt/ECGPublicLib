//
//  ECGCustomCell.h
//  ECGCustomCellDemo
//
//  Created by tan on 2017/3/6.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGModel.h"

@interface ECGCustomCell : UITableViewCell

@property(nonatomic, strong) ECGModel *ECGModel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *introductionLabel;
@property (strong, nonatomic) UIImageView *userPhoto;

@end
