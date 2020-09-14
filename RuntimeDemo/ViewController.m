//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 承启通 on 2020/9/10.
//  Copyright © 2020 承启通. All rights reserved.
//

#import "ViewController.h"
#import "PartOneViewController.h"
#import "PartTwoViewController.h"
#import "PartThreeViewController.h"
#include "objc/runtime.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * tableView;
    NSMutableArray * dataArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dataArr = [[NSMutableArray alloc]initWithObjects:@"消息动态解析",@"消息接受者重定向",@"消息重定向", nil];
    tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            PartOneViewController * viewCtr = [[PartOneViewController alloc] init];
            [self presentViewController:viewCtr animated:YES completion:nil];
        }
            break;
        case 1:
        {
            PartTwoViewController * viewCtr = [[PartTwoViewController alloc] init];
            [self presentViewController:viewCtr animated:YES completion:nil];
        }
            break;
        case 2:
        {
            PartThreeViewController * viewCtr = [[PartThreeViewController alloc] init];
            [self presentViewController:viewCtr animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
