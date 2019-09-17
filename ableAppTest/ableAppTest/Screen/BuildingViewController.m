//
//  BuildingViewController.m
//  ableAppTest
//
//  Created by JoonHo Kang on 11/09/2019.
//  Copyright © 2019 JoonHo Kang. All rights reserved.
//

#import "BuildingViewController.h"
#import "BuildingController.h"
#import "LoginViewController.h"
#import "CommonUtil.h"
#import "UserInfo.h"
#import "CommonFileUtil.h"
#import "ResourceManager.h"
#import "CCDropDownMenus.h"
#import "IGLDropDownMenu.h"
#import "FhcComboBoxView.h"
#import "KPDropMenu.h"


@interface BuildingViewController ()
{
//    UIScrollView * contentsView;
    UIPageControl * pageControl;
    int m_nCurGroupIdx;
    int currentIndex;
    int maxGroupCount;
    
    NSMutableArray * arrBuilding;
    
    BuildingController * currentView;
    BuildingController * prevView;
    BuildingController * nextView;
    __weak IBOutlet UIScrollView *contentsView;
    
    
    NSArray * arrData;
    NSArray * arrSortedData;
    
}

@end

@implementation BuildingViewController

- (void)viewDidLoad {
    
    // not login info
    if (![[UserInfo instance] isUserLogin])
    {
     //   [LoginViewController ShowLoginView:@"" animated:NO];
    }
    


    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    self.showBack = YES;
    self.showMyMenu = YES;
    
    [self setTitleText:@""];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    ManaDropDownMenu *menu = [[ManaDropDownMenu alloc] initWithFrame:_viewWork.bounds title:@"방수공사"];
    menu.delegate = self;
    menu.numberOfRows = 2;
    menu.textOfRows = @[@"방수공사", @"배선공사"];
//    [_viewWork addSubview:menu];
    
    
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
    [item setIconImage:[UIImage imageNamed:@"icon.png"]];
    [item setText:@"방수공사"];
    [dropdownItems addObject:item];
    item = [[IGLDropDownItem alloc] init];
    [item setIconImage:[UIImage imageNamed:@"icon.png"]];
    [item setText:@"배선공사"];
    [dropdownItems addObject:item];

    
    IGLDropDownMenu *dropDownMenu = [[IGLDropDownMenu alloc] initWithFrame:_viewWork.bounds];
//    [dropDownMenu setFrame:CGRectMake(0, 0, 200, 45)];
    dropDownMenu.menuText = @"Choose Weather";
    dropDownMenu.menuIconImage = [UIImage imageNamed:@"chooserIcon.png"];
    dropDownMenu.paddingLeft = 15;  // padding left for the content of the butto
    [_viewWork addSubview:dropDownMenu];

    dropDownMenu.type = IGLDropDownMenuTypeStack;
    dropDownMenu.gutterY = 5;
    dropDownMenu.itemAnimationDelay = 0.1;
    dropDownMenu.rotate = IGLDropDownMenuRotateRandom;
    
//    [dropDownMenu reloadView];
    
    
    KPDropMenu *dropNew = [[KPDropMenu alloc] initWithFrame:_viewWork.bounds];
    dropNew.delegate = self;
    dropNew.items = @[@"방수공사", @"배선공사"];
    dropNew.title = @"공사선택";
    dropNew.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:16.0];
    dropNew.titleTextAlignment = NSTextAlignmentCenter;
    dropNew.itemHeight = 60;
    dropNew.DirectionDown = NO;
    
    CGRect rect = _viewWork.frame;
    
    
    rect = [_viewBottom convertRect:rect toView:self.view];
    
    dropNew.frame = rect;
    dropNew.tag = 101;
    
    [self.view addSubview:dropNew];
    
    
    
    KPDropMenu *dropDong = [[KPDropMenu alloc] initWithFrame:_viewDongSel.bounds];
    dropDong.delegate = self;
    
    dropDong.items = arrSortedData;
    dropDong.title = @"작업동선택";
    dropDong.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:16.0];
    dropDong.titleTextAlignment = NSTextAlignmentCenter;
    dropDong.itemHeight = 50;
    dropDong.DirectionDown = NO;
    dropDong.tag = 102;
    
    rect = _viewDongSel.frame;
    
    
    rect = [_viewBottom convertRect:rect toView:self.view];
    
    dropDong.frame = rect;
    
    [self.view addSubview:dropDong];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex;
{
    
    if (dropMenu.tag == 101)
    {
        if (atIntedex == 0)
            _str_disp_mode = @"Work_waterproof";
        else if (atIntedex == 1)
            _str_disp_mode = @"Work_wiring";
        else
            _str_disp_mode = @"";
        if (currentView)
        {
            [self updateDispMode:_str_disp_mode];
    //        [currentView refreshData];
        }
    }
    else
    {
        int idx = atIntedex;
        
        [self gotoGroupIndx:idx];
    }
}

-(void)didShow : (KPDropMenu *)dropMenu;
{
}

-(void)didHide : (KPDropMenu *)dropMenu;
{
}

- (void) initData
{

    
    NSString * sPath = [NSString stringWithFormat:@"main/%@", FOLDER_RESOURCE];
    NSString *fileName    = [CommonFileUtil getResFilePath:sPath fileName:@"apart.json"];
    NSString *dataString= @"";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
        dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    if (dataString != nil)
    {
        NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        
        
        arrData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
        
        
        
        NSLog(@"%@,", arrData);
        NSLog(@"%d", arrData.count);
    }
    
    
    
    if (arrData == nil)
    {
        arrData = [[NSArray alloc] init];
    }
    
    
    
    NSMutableDictionary  * dicDong = [[NSMutableDictionary alloc] init];
    
    
    
    for (int i=0; i<arrData.count-1; i++)
    {
        NSMutableDictionary * dic = arrData[i];
        
        NSString * strDong = dic[@"Dong"];
        
        
        if (strDong != nil && strDong.length > 0)
        {
            NSMutableArray * arrDongData = dicDong[strDong];
            
            if (arrDongData == nil)
            {
                arrDongData = [[NSMutableArray alloc] init];
                dicDong[strDong] = arrDongData;
            }
            
            [arrDongData addObject:dic];
        }
    }
    
    CGRect r = [UIScreen mainScreen].bounds;//  self.view.frame;
    r.size.height -= (_viewBottom.frame.size.height + self.navigationController.navigationBar.frame.size.height + 20);
    contentsView.bounds = r;
    
    CGSize sz = contentsView.frame.size;
    sz.width = contentsView.frame.size.width * 3;
    contentsView.contentSize = sz;
    contentsView.delegate    = self;
    contentsView.pagingEnabled = YES;
    contentsView.backgroundColor = [UIColor greenColor];
    contentsView.bounces = NO;
    
    contentsView.contentOffset = CGPointMake(contentsView.frame.size.width, 0);
    contentsView.showsVerticalScrollIndicator = NO;
    contentsView.showsHorizontalScrollIndicator = NO;

    pageControl = [[UIPageControl alloc] init];
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.view addSubview:_pageControl];
    pageControl.numberOfPages = 10;//MAX_GROUP_COUNT;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
//    m_nCurGroupIdx = [CommonUtil getIntegerForKey:@"fav.group.idx" basic:0] ;
    
    
    maxGroupCount = dicDong.count;
    arrBuilding = [[NSMutableArray alloc] init];
    
    
    
    
    NSArray * dataArray = [dicDong allKeys];
    
    
    
    NSArray *arrSorted = [dataArray sortedArrayUsingComparator:^(NSString *a, NSString *b){
        return [a compare:b];
    }];
    
    
    arrSortedData = arrSorted;
    
    for (int i=0; i<arrSorted.count; i++)
    {
        BuildingController * v = [[BuildingController alloc] initWithNibName:@"BuildingController" bundle:nil];
        v.arrDongInfo = dicDong[arrSorted[i]];
        v.strDong = [arrSorted[i] copy];
        
        
        CGRect r = contentsView.bounds;
//        r.size.height -= (_viewBottom.frame.size.height + self.navigationController.navigationBar.frame.size.height + 20);;
//        r.size.height -= _viewBottom.frame.size.height;
        r.origin.x = i * self.view.frame.size.width;
        v.view.frame = r;
        
        [contentsView addSubview:v.view];
        
        UILabel * lb = [[UILabel alloc] initWithFrame:v.view.bounds];
        lb.text = [NSString stringWithFormat:@"%@", arrSorted[i]];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:50];
        
        [v.view addSubview:lb];
        
        
        [arrBuilding addObject:v];
    }
    
    
    [self gotoGroupIndx:0];

}

- (void) layoutSubviews
{
    CGRect r = [UIScreen mainScreen].bounds;//  self.view.frame;
    r.size.height -= _viewBottom.frame.size.height ;
    contentsView.bounds = r;

    for (int i=0; i<arrBuilding.count; i++)
    {
        BuildingController * v = arrBuilding[i];
        
        CGRect r = contentsView.bounds;
        r.origin.x = i * self.view.frame.size.width;
        v.view.frame = r;
    }
}


- (void) updateDispMode:(NSString *) sCmd
{
    for (int i=0; i<arrBuilding.count; i++)
    {
        BuildingController * v = arrBuilding[i];
        
        v.str_disp_mode = sCmd;
        if (v.visible) [v refreshData];
    }
}

#pragma UISCrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    
    if (scrollView == contentsView)
    {
        int move = (scrollView.contentOffset.x / self.view.frame.size.width);
        
        // 1인경우는 그대로 화면 유지
        if(move == 1) return;
        currentIndex = currentIndex + (move - 1);
        
        
        if (currentIndex == -1)
            currentIndex = maxGroupCount - 1;
        else if (currentIndex == maxGroupCount)
            currentIndex = 0;
        
        [self gotoGroupIndx:currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (scrollView == contentsView)
    {
//        [self showDirectionButton:YES];
        
//        [self gotoPrepareGroupIndx:currentIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (scrollView == contentsView)
    {
//        [self startDirectionTimer];
    }
}


- (void) gotoGroupIndx:(NSInteger) nIdx
{
    @try
    {
        if (arrBuilding.count == 0) return;
        if (nIdx == -1) return;
        
//        if(maxGroupCount>0)
//            [self showDirectionButton:YES];
        
        currentIndex = nIdx;
        
        if (currentIndex < 0) currentIndex = maxGroupCount - 1;
        if (currentIndex >= maxGroupCount) currentIndex = 0;
        
        int pv = [self getPrevView:currentIndex -1];
        int nx = [self getNextView:currentIndex + 1];
        if (pv < 0) pv = maxGroupCount - 1;
        if (pv < 0) pv = 0;
        if (nx >= maxGroupCount ) nx = 0;
        
        
        
        prevView  = [arrBuilding objectAtIndex:pv];
        currentView = [arrBuilding objectAtIndex:currentIndex];
        nextView  = [arrBuilding objectAtIndex:nx];
        
        
        [self updateDispMode:_str_disp_mode];
        
        if (prevView) [prevView buildData];
        if (currentView) [currentView buildData];
        if (nextView) [nextView buildData];

        
        [prevView.view setNeedsDisplay];
        [currentView.view setNeedsDisplay];
        [nextView.view setNeedsDisplay];

        
        CGRect r = prevView.view.frame;
        
        r.origin.x = 0;
        prevView.view.frame = r;
        
        r.origin.x += r.size.width;
        currentView.view.frame = r;
        
        
        r.origin.x += r.size.width;
        nextView.view.frame = r;
        
        [contentsView bringSubviewToFront:prevView.view];
        [contentsView bringSubviewToFront:currentView.view];
        [contentsView bringSubviewToFront:nextView.view];
        
        contentsView.contentOffset = currentView.view.frame.origin;
        
        pageControl.currentPage = currentIndex;
        
        contentsView.scrollEnabled = YES;
        
//        [currentView loadForm:m_nCurOptionView];
        
        //        [prevView loadForm:m_nCurOptionView];
        //        [nextView loadForm:m_nCurOptionView];
        
        contentsView.scrollEnabled = (maxGroupCount > 1);
        
//        [self startDirectionTimer];
        
        //    [self performSelector:@selector(tickerShow) withObject:nil afterDelay:0.01f];
    } @catch (NSException *exception) {
        NSLog(@"Crash Report Bugfix Work");
    } @finally {
        
    }
    
}

- (int) getPrevView:(int) nValue
{
    
    for (int i=nValue; i>=0; i--)
    {
        BuildingController * v = arrBuilding[i];
        if (v.visible)
        {
            return i;
        }
    }
    return -1;
}


- (int) getNextView:(int) nValue{
    
    for (int i=nValue; i<maxGroupCount; i++)
    {
        BuildingController * v = arrBuilding[i];
        if (v.visible)
        {
            return i;
        }
    }
    return maxGroupCount;
}

- (void) gotoPrepareGroupIndx:(NSInteger) nIdx
{
    @try
    {
        if (arrBuilding.count == 0) return;
        if (nIdx == -1) return;
        
//        if(maxGroupCount>0)
//            [self showDirectionButton:YES];
        
        int pv = [self getPrevView:nIdx -1];
        int nx = [self getNextView:nIdx + 1];
        if (pv < 0) pv = maxGroupCount - 1;
        if (pv < 0) pv = 0;
        if (nx >= maxGroupCount ) nx = 0;
        
        prevView  = [arrBuilding objectAtIndex:pv];
        nextView  = [arrBuilding objectAtIndex:nx];
        
        
        CGRect r = currentView.view.frame;
        
        r.origin.x = 0;
        prevView.view.frame = r;
        
        
        r.origin.x = r.size.width * 2;
        nextView.view.frame = r;
        
        [contentsView bringSubviewToFront:prevView.view];
        [contentsView bringSubviewToFront:nextView.view];
        
//        [prevView prepareShowBefore];
//        [nextView prepareShowBefore];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Crash Report Bugfix Work");
    } @finally {
        
    }
}

- (IBAction)onDongClick:(id)sender {
    
    [self.view bringSubviewToFront:_pickerView];
    
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrBuilding.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BuildingController * v =arrBuilding[row];
    return v.strDong;
}

@end
