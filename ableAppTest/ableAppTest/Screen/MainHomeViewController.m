//
//  MainHomeViewController.m
//  Muffin
//
//  Created by JoonHo Kang on 26/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MainHomeViewController.h"
#import "LoginViewController.h"
#import "CommonUtil.h"
#import "UserInfo.h"


@interface MainHomeViewController ()
{
}

@end

@implementation MainHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    m_keyboardManager = [[KeyboardManager alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view from its nib.
    
    
    // not login info
    if (![[UserInfo instance] isUserLogin])
    {
        [LoginViewController ShowLoginView:@"" animated:NO];
    }
    
    
    [self initLayout];
    [self initData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) initLayout
{


}

- (void) initData
{

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:@"song_cell"];
    

    
    return cell;
}






- (void) onRefresh;
{
    [self initData];
}
- (IBAction)onClickMuffin:(id)sender {
    
//    ProjectMakeController * viewController =  [[ProjectMakeController alloc] initWithNibName:@"ProjectMakeController" bundle:nil];
//    [self.navigationController  pushViewController:viewController animated:YES];
    
//    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)onClickBanner:(id)sender {
//    BannerViewController * banner = [[BannerViewController alloc] initWithNibName:@"BannerViewController" bundle:nil];
//    [self.navigationController  pushViewController:banner animated:YES];
}

@end
