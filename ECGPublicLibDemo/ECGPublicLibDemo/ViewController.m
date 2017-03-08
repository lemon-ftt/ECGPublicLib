//
//  ViewController.m
//  ECGPublicLibDemo
//
//  Created by tan on 2017/3/7.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ECGCustomCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.superview).offset(20);
        make.left.equalTo(tableView.superview.mas_left);
        make.right.equalTo(tableView.superview.mas_right);
        make.bottom.equalTo(tableView.superview.mas_bottom);
    }];
    
    //高度自适应最重要的两句话，不用再给高度了
    tableView.estimatedRowHeight = 40; //估算高度
    tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECGCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[ECGCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor greenColor];
        //        cell.backgroundColor = [UIColor colorWithRed:arc4random() % 110 * 0.1 green:arc4random() % 110 * 0.1 blue:arc4random() % 110 * 0.1 alpha:1.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ECGModel *model = [[ECGModel alloc]init];
    
    if (indexPath.row == 0)
    {
        model.name = @"numn.1";
        model.introduction = @"12345678976543214567854324567865432456786543245";
        //        model.imgName = @"";
        
    }
    else if(indexPath.row == 1)
    {
        model.name = @"num.2";
        //        model.introduction = @"adfsgdhjklggfdsdafghjklhgfdsaDFGHJKLHGF";
        //        model.imgName = @"";
    }
    else if(indexPath.row == 2)
    {
        model.name = @"num.3";
        model.introduction = @"收到了发哈看了好久放假哎活动房环球而强迫你覅偶后覅和企鹅王if好奇问废话IQ而恢复IQ了发哈看了好久放假哎活动房环球而强迫你覅偶后覅和企鹅王if好奇问废话IQ而恢复IQ了发哈看了好久放假哎活动房环球而强迫你覅偶后覅和企鹅王if好奇问废话IQ而恢复IQ了发哈看了好久放假哎活动房环球而强迫你覅偶后覅和企鹅王if好奇问废话IQ而恢复IQ";
        //        model.imgName = @"";
        
    }
    
    cell.ECGModel = model;
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
