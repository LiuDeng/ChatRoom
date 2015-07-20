//
//  SettingViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/18.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor primaryBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogoutAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)LogoutAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[LoginManager shareManager] Logout];
    }];
}

- (IBAction)BackPress:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
