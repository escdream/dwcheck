//
//  BuildingController.h
//  ableAppTest
//
//  Created by JoonHo Kang on 11/09/2019.
//  Copyright © 2019 JoonHo Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuildingController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblBuild;

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, strong) NSMutableArray * arrDongInfo;

@property (nonatomic, strong) NSString * str_disp_mode;
@property (nonatomic, strong) NSString * strDong;


- (void) buildData;
- (void) refreshData;

@end

NS_ASSUME_NONNULL_END
