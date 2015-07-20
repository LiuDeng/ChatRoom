//
//  ViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/17.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ICETutorialControllerDelegate>

@property (nonatomic, strong) ICETutorialController * viewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
       
        if (idx == 0) {
            
            obj.title = @"Voice Room";
            obj.image = [UIImage imageNamed:@"tab_music"];
        } else {
            
            obj.title = @"Video Room";
            obj.image = [UIImage imageNamed:@"tab_movie"];
        }
    }];
    
    self.tabBar.selectedImageTintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor primaryBackgroundColor];
    self.tabBar.translucent = NO;
    
    @weakify(self);
    [RACObserve([LoginManager shareManager], isLogin) subscribeNext:^(NSNumber * x) {
        
        @strongify(self);
        if ([x boolValue] == YES) {
            
            
        } else {
            
            [self LoadGuideView];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (NO == [defaults boolForKey:@"ApplicationFirstLaunch"]) {
        
        [self LoadGuideView];
    }
}

- (void)LoadGuideView {
    
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"Evening..."
                                                            subTitle:@"Lonely, need to relieve the sound"
                                                         pictureName:@"tutorial_background_00@2x.jpg"
                                                            duration:5.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"On the way..."
                                                            subTitle:@"Time passed, Video with your family"
                                                         pictureName:@"tutorial_background_02@2x.jpg"
                                                            duration:5.0];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"Travel..."
                                                            subTitle:@"To share the beauty"
                                                         pictureName:@"tutorial_background_04@2x.jpg"
                                                            duration:5.0];
    NSArray *tutorialLayers = @[layer1, layer3, layer5];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.viewController = [[ICETutorialController alloc] initWithPages:tutorialLayers
                                                              delegate:self];
    
    // Run it.
    [self.viewController startScrolling];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:_viewController] animated:YES completion:nil];
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {

    // Login
    [_viewController.navigationController pushViewController:[LoginViewController new] animated:YES];
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    
    // Register
    [_viewController.navigationController pushViewController:[RegistViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
