//
//  StartupPopupView.m
//  Muffin
//
//  Created by escdream on 2018. 10. 2..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "StartupPopupView.h"
#import "UserInfo.h"
#import "CommonUtil.h"
#import "SystemUtil.h"

@interface StartupPopupView ()

@end

@implementation StartupPopupView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    if ([[SystemUtil instance] isIPhoneX] )
    {
        CGRect ar = [CommonUtil getWindowArea];
        
        ar.size.height += ar.origin.y + 90 + 60;
        ar.origin.y = 0;
        _imgBackground.bounds = ar;
    }
    
    
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
- (IBAction)onFacebookSign:(id)sender {

}
- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
