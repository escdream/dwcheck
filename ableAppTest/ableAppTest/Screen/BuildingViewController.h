//
//  BuildingViewController.h
//  ableAppTest
//
//  Created by JoonHo Kang on 11/09/2019.
//  Copyright © 2019 JoonHo Kang. All rights reserved.
//

#import "ViewController.h"
#import "EDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuildingViewController : EDBaseViewController
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIView *viewWork;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIView *viewDongSel;
@property (nonatomic, strong) NSString * str_disp_mode;
@end

NS_ASSUME_NONNULL_END
