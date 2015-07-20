//
//  LoginViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/18.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField * userNameText;
@property (nonatomic, strong) UITextField * passWordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Login";
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login !" style:UIBarButtonItemStylePlain target:self action:@selector(LoginAction)];
    
    // View Build
    
    /**< White Area */
    
    UIView * whiteArea = [[UIView alloc] initWithFrame:CGRectMake(12, 20, [UIScreen mainScreen].bounds.size.width - 24, 80.5)];
    whiteArea.backgroundColor = [UIColor whiteColor];
    whiteArea.layer.masksToBounds = YES;
    whiteArea.layer.cornerRadius = 4;
    [self.view addSubview:whiteArea];
    
    /**< Sep Line, Text Field*/
    
    _userNameText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(whiteArea.frame), 40)];
    _userNameText.layer.cornerRadius = 4;
    _userNameText.layer.masksToBounds = YES;
    _userNameText.placeholder = @" Mobile Phone Number";
    _userNameText.textColor = [UIColor primaryBackgroundColor];
    _userNameText.font = [UIFont systemFontOfSize:14.];
    [whiteArea addSubview:_userNameText];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userNameText.frame), CGRectGetWidth(whiteArea.frame), .5)];
    line.backgroundColor = [UIColor primaryBackgroundColor];
    [whiteArea addSubview:line];
    
    _passWordText = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(whiteArea.frame), 40)];
    _passWordText.layer.cornerRadius = 4;
    _passWordText.layer.masksToBounds = YES;
    _passWordText.placeholder = @" Account Pass word, remember it.";
    _passWordText.textColor = [UIColor primaryBackgroundColor];
    _passWordText.font = [UIFont systemFontOfSize:14.];
    [whiteArea addSubview:_passWordText];
    
    _userNameText.textAlignment = NSTextAlignmentCenter;
    _passWordText.textAlignment = NSTextAlignmentCenter;
    
    _userNameText.keyboardType = UIKeyboardTypeNumberPad;
    _passWordText.secureTextEntry = YES;
    
    _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _userNameText.tintColor = [UIColor primaryBackgroundColor];
    _passWordText.tintColor = [UIColor primaryBackgroundColor];
    
    _userNameText.keyboardAppearance = UIKeyboardAppearanceDark;
    _passWordText.keyboardAppearance = UIKeyboardAppearanceDark;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_userNameText becomeFirstResponder];
}

- (void)LoginAction {
    
    // Login Success, Set Login Yet
    
    [self.view endEditing:YES];
    
    if ([self AuthText:_userNameText.text] && [self AuthText:_passWordText.text]) {
        
        [[LoginManager shareManager] Login:_userNameText.text pass:_passWordText.text];
        
        @weakify(self);
        [RACObserve([LoginManager shareManager], isLogin) subscribeNext:^(NSNumber * x) {
            
            @strongify(self);
            if ([x boolValue] == YES) {
                
                [RKDropdownAlert title:@"Welcome Back" backgroundColor:[UIColor secondaryBackgroundColor] textColor:[UIColor whiteColor]];
                
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"ApplicationFirstLaunch"];
                [defaults synchronize];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                
                [self.view shakeView];
            }
        }];
        
    } else {
        
        [self.view shakeView];
    }
}

- (BOOL)AuthText: (NSString *)text {
    
    return text.length > 0 && text != nil && ![text isEqualToString:@""];
}

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
