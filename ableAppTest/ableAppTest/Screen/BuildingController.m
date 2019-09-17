//
//  BuildingController.m
//  ableAppTest
//
//  Created by JoonHo Kang on 11/09/2019.
//  Copyright © 2019 JoonHo Kang. All rights reserved.
//

#import "BuildingController.h"

@interface UIButtonWithDic : UIButton
@property (nonatomic, strong) NSMutableDictionary * dic;

@end;

@implementation UIButtonWithDic
@end






@interface BuildingController ()
{
    NSMutableArray * arrFloor;
    NSMutableDictionary * dicFloor;
}

@end

@implementation BuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dicFloor = [[NSMutableDictionary alloc] init];
    
    [_tblBuild setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _visible = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) buildData
{
    
    _arrDongInfo;
    
    
    for (NSDictionary * dic in _arrDongInfo)
    {
        NSString * strFloor = dic[@"Floor"];
        
        if (strFloor != nil && strFloor.length > 0)
        {
            NSMutableArray * arr = dicFloor[strFloor];
            if (arr == nil)
            {
                arr = [[NSMutableArray alloc] init];
                dicFloor[strFloor] = arr;
            }
            [arr addObject:dic];
        }
    }

    NSArray *arrSorted = [[dicFloor allKeys] sortedArrayUsingComparator:^(NSString *a, NSString *b){
        
        if ( [a integerValue] > [b integerValue])
            return NSOrderedAscending;
        else if ( [a integerValue] < [b integerValue])
            return NSOrderedDescending;
        
        return NSOrderedSame;
    }];


    arrFloor = [[NSMutableArray alloc] initWithArray:arrSorted];
    
    
  
    _tblBuild.frame = self.view.bounds;
    
    [_tblBuild reloadData];
    [_tblBuild setNeedsDisplay];
    
    
    [self performSelector:@selector(gotoBottom) withObject:nil afterDelay:0.2];
    
//    if (self.tblBuild.contentSize.height > self.tblBuild.frame.size.height)
//    {
//        CGPoint offset = CGPointMake(0, self.tblBuild.contentSize.height - self.tblBuild.frame.size.height);
//        [self.tblBuild setContentOffset:offset animated:YES];
//    }
}

- (void) gotoBottom
{
    if (arrFloor.count > 0)
    {
        [self.tblBuild scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrFloor.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.tblBuild.contentSize.height > self.tblBuild.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tblBuild.contentSize.height - self.tblBuild.frame.size.height);
        [self.tblBuild setContentOffset:offset animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFloor.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"build_cell"];
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"build_cell"];
        
        CGFloat w = tableView.frame.size.width;
        CGFloat sx = 0;
        CGFloat sw = 40;
        CGFloat bw = (w - 50 - 25) / 4;
        
        
        UIButton * btnFloor = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect r = CGRectMake(5, 5, 40, 40);
        btnFloor.tag = 1000000;
        btnFloor.frame = r;
        btnFloor.backgroundColor = [UIColor grayColor];
        [cell addSubview:btnFloor];
        
        for (int i=0; i<4; i++)
        {
            r = CGRectMake(50 + (5*i) + (bw * i), 5, bw, 40);
            UIButtonWithDic * btnHo = [UIButtonWithDic buttonWithType:UIButtonTypeCustom];
            btnHo.tag = 1000001 + i;
            btnHo.frame = r;
            btnHo.backgroundColor = [UIColor lightGrayColor];
            
            [btnHo addTarget:self action:@selector(onBtnHoClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:btnHo];
        }
    }

    NSString * strFloor = [NSString stringWithFormat:@"%@", arrFloor[indexPath.row]];
    NSMutableArray * arr = dicFloor[strFloor];

    
    UIButton * bFloor = [cell viewWithTag:1000000];
    [bFloor setTitle:strFloor forState:UIControlStateNormal];



    for (int i=0; i<arr.count; i++)
    {
        UIButtonWithDic * btnHo = [cell viewWithTag:1000001 + i];
        
        NSDictionary * dic = arr[i];
        btnHo.dic = arr[i];
        
        NSString * sHo = [NSString stringWithFormat:@"%@%@호", dic[@"Floor"], dic[@"Ho"]];
        [btnHo setTitle:sHo forState:UIControlStateNormal];
        
        BOOL isChanged = NO;
        if (dic)
        {
            
            if ([_str_disp_mode isEqualToString:@"Work_waterproof"])
            {
                if ([dic[@"Work_waterproof"] isEqualToString:@"Y"])
                {
                    btnHo.backgroundColor = [UIColor redColor];
                    isChanged = YES;
                }
            }
            else if ([_str_disp_mode isEqualToString:@"Work_wiring"])
            {
                if([dic[@"Work_wiring"] isEqualToString:@"Y"])
                {
                    btnHo.backgroundColor = [UIColor greenColor];
                    isChanged = YES;
                }
            }
            
            if (isChanged == NO)
                btnHo.backgroundColor = [UIColor lightGrayColor];
        }
    }

    return cell;
}


- (void) refreshData;
{
    [_tblBuild reloadData];
}


- (void) onBtnHoClick:(UIButton *) btn
{
    
    UIButtonWithDic * abtn = (UIButtonWithDic *) btn;
    NSMutableDictionary * dic = abtn.dic;
    
    if (dic)
    {
        
        if ([_str_disp_mode isEqualToString:@"Work_waterproof"])
        {
            if ([dic[@"Work_waterproof"] isEqualToString:@"Y"])
            {
                dic[@"Work_waterproof"] = @"N";
                btn.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                dic[@"Work_waterproof"] = @"Y";
                btn.backgroundColor = [UIColor redColor];
            }

        }
        else if ([_str_disp_mode isEqualToString:@"Work_wiring"])
        {
            if([dic[@"Work_wiring"] isEqualToString:@"Y"])
            {
                dic[@"Work_wiring"] = @"N";
                btn.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                dic[@"Work_wiring"] = @"Y";
                btn.backgroundColor = [UIColor greenColor];
            }
        }
    }
}




@end
