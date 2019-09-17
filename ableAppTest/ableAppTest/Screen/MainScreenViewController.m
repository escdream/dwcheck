//
//  MainScreenViewController.m
//  Muffin
//
//  Created by escdream on 2018. 9. 1..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "MainScreenViewController.h"

#import "LoginViewController.h"
#import "ResourceManager.h"
#import "SystemUtil.h"
#import "CommonUtil.h"
#import "StartupPopupView.h"
#import "NSString+Format.h"
#import "UserInfo.h"
#import "BuildingViewController.h"




@interface MainScreenViewController ()
{
    NSMutableArray * arrMakeList;
    NSMutableArray * arrArtistsList;
}


@end

@implementation MainScreenViewController

- (void) initLayout
{
    
//    CGRect ar = [CommonUtil getWindowArea];
//    
//    
//    CGRect r = _viewUserInfo.frame;
//    r.origin.y += ar.origin.y;
//    _viewUserInfo.frame = r;
//    
//    r = _tblInfoList.frame;
//    r.origin.y += ar.origin.y;
//    
//    if ([[SystemUtil instance] isIPhoneX])
//        r.size.height += 100;
//
//    
//    _tblInfoList.frame = r;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self initUserData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    m_keyboardManager = [[KeyboardManager alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self initLayout];

    // not login info
//    if (![[UserInfo instance] isUserLogin])
    {
       // [LoginViewController ShowLoginView:@"" animated:NO];
    }
    
    self.showMyMenu = FALSE;
//    [self initUserData];
    
    
//    [_viewTabs addTab:@"test1"];
//    [_viewTabs addTab:@"test2"];
//    [_viewTabs addTab:@"test3"];
//
//    UIView * v = (UIView *)(_viewTabs.tabViewList[0]);
//
//    _tblInfoList.frame = v.bounds;
//
//    [v addSubview:_tblInfoList];
//
    [self showBuilding];
}

- (void) showBuilding
{
    BuildingViewController * controler = [[BuildingViewController alloc] initWithNibName:@"BuildingViewController" bundle:nil];


    [self.navigationController pushViewController:controler animated:YES];
}
    


- (void) initUserData
{
    _lbID.text = [UserInfo instance].userID;
    _lbPoint.text = [[NSString stringWithFormat:@"%d", [UserInfo instance].muffinPoint] decimalString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)onSearchView:(id)sender {
    [self showBuilding];
}


@end
