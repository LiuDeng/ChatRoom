//
//  BaseViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor primaryBackgroundColor];
}

- (void)setTabBarHidden:(BOOL)hidden {
    UIView *tab = self.tabBarController.view;
    
    if ([tab.subviews count] < 2) {
        
        return;
    }
    
    UIView *view;
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        
        view = [tab.subviews objectAtIndex:1];
    } else {
        
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        
        view.frame = tab.bounds;
    } else {
        
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    
    self.tabBarController.tabBar.hidden = hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
