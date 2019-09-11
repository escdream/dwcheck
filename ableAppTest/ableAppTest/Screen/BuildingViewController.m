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

@interface BuildingViewController ()
{
    UIScrollView * contentsView;
    UIPageControl * pageControl;
    int m_nCurGroupIdx;
    int currentIndex;
    int maxGroupCount;
    
    NSMutableArray * arrBuilding;
    
    BuildingController * currentView;
    BuildingController * prevView;
    BuildingController * nextView;
}

@end

@implementation BuildingViewController

- (void)viewDidLoad {
    
    // not login info
    if (![[UserInfo instance] isUserLogin])
    {
     //   [LoginViewController ShowLoginView:@"" animated:NO];
    }
    
    self.showBack = NO;
    self.showMyMenu = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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


- (void) initData
{

    
    CGRect r = [UIScreen mainScreen].bounds;//  self.view.frame;
    
    r.origin.y += CALCUTIL_VERT_HEIGHT(10);
    r.size.height -= CALCUTIL_VERT_HEIGHT(10);
    contentsView = [[UIScrollView alloc] initWithFrame:r];
    
//    [self.view insertSubview:contentsView aboveSubview:self.view];
    [self.view addSubview:contentsView];

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
    
    
    maxGroupCount = 10;
    arrBuilding = [[NSMutableArray alloc] init];
    
    for (int i=0; i<maxGroupCount; i++)
    {
        BuildingController * v = [[BuildingController alloc] initWithNibName:@"BuildingController" bundle:nil];
        CGRect r = [UIScreen mainScreen].bounds;
        r.origin.x = i * self.view.frame.size.width;
        v.view.frame = r;
        
        [contentsView addSubview:v.view];
        
        UILabel * lb = [[UILabel alloc] initWithFrame:v.view.bounds];
        lb.text = [NSString stringWithFormat:@"%0d", i+1];
        lb.textAlignment = NSTextAlignmentCenter;
        
        [v.view addSubview:lb];
        
        
        [arrBuilding addObject:v];
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



@end
