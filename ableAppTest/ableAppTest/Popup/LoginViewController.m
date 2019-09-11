//
//  LoginViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigationController.h"
#import "MainViewController.h"
#import "LGAlertView.h"
#import "UserInfo.h"
#import "StartupPopupView.h"
#import "NSString+Format.h"

#import "CommonUtil.h"
#import "SystemUtil.h"

@interface LoginViewController ()
{
    BOOL m_bKeyboardShow;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 노티피케이션 등록.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    


    
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

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [nc removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) doUserLoginCheck
{
    [self setEditing:FALSE];
    
 
    
    NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] init];
    dicParam[@"UserId"] = _txtID.text;
    
}
- (IBAction)OnSignUp:(id)sender {
    
}

- (IBAction)onLoginClick:(id)sender {
//    _txtID.text = _testID.text;
    _txtPwd.text = @"1111";
    
//    if ([[_txtID.text trim] isEqualToString:@""] || [[_txtPwd.text trim] isEqualToString:@""])
//    {
//        [[[LGAlertView alloc] initWithTitle:@"안내"
//                                    message:@"ID 또는 Password 를 입력해주세요"
//                                      style:LGAlertViewStyleAlert
//                               buttonTitles:nil
//                          cancelButtonTitle:@"확인"
//                     destructiveButtonTitle:nil
//                                   delegate:nil] showAnimated:YES completionHandler:nil];
//    }
//    else
    {
        
        
        [self doUserLoginCheck];
        
        
    }
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void) ShowLoginView:(NSString *) sData animated:(BOOL) animated
{
    LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:loginView animated:animated completion:nil];
}





- (void)keyboardWillShow:(NSNotification *)note {
    
    if (m_bKeyboardShow)
    {
        return ;
    }
    m_bKeyboardShow = YES;
    NSDictionary *userInfo = [note userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    float height = keyboardRect.size.height-60;
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (void)keyboardDidShow:(NSNotification *)note {
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    float height = keyboardRect.size.height-60;
    self.view.frame = CGRectMake(self.view.frame.origin.x,         self.view.frame.origin.y + height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    m_bKeyboardShow = NO;
}


- (void)keyboardDidHide:(NSNotification *)notification {
    

    
    //    [[ExceptionManager sharedInstance] removeKeyboardBackgroundView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self onLoginClick:nil];
    
    return YES;
}


-(void)dismissKeyboard:(id)sender
{
     [self.view endEditing:YES];
}




@end
