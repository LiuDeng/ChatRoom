//
//  RegistViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/18.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@property (nonatomic, strong) UITextField * nickName;
@property (nonatomic, strong) UITextField * userNameText;
@property (nonatomic, strong) UITextField * passWordText;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Regist New Account";
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Regist !" style:UIBarButtonItemStylePlain target:self action:@selector(RegistAction)];
    
    // View Build
    
    /**< White Area */
    
    UIView * whiteArea = [[UIView alloc] initWithFrame:CGRectMake(12, 20, [UIScreen mainScreen].bounds.size.width - 24, 120.1)];
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
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_passWordText.frame), CGRectGetWidth(whiteArea.frame), .5)];
    line.backgroundColor = [UIColor primaryBackgroundColor];
    [whiteArea addSubview:line];
    
    _nickName = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(whiteArea.frame), 40)];
    _nickName.layer.cornerRadius = 4;
    _nickName.layer.masksToBounds = YES;
    _nickName.placeholder = @" NickName, Cute";
    _nickName.textColor = [UIColor primaryBackgroundColor];
    _nickName.font = [UIFont systemFontOfSize:14.];
    [whiteArea addSubview:_nickName];
    
    _userNameText.textAlignment = NSTextAlignmentCenter;
    _passWordText.textAlignment = NSTextAlignmentCenter;
    _nickName.textAlignment = NSTextAlignmentCenter;
    
    _userNameText.keyboardType = UIKeyboardTypeNumberPad;
    _passWordText.secureTextEntry = YES;
    
    _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _userNameText.tintColor = [UIColor primaryBackgroundColor];
    _passWordText.tintColor = [UIColor primaryBackgroundColor];
    _nickName.tintColor = [UIColor primaryBackgroundColor];
    
    _userNameText.keyboardAppearance = UIKeyboardAppearanceDark;
    _passWordText.keyboardAppearance = UIKeyboardAppearanceDark;
    _nickName.keyboardAppearance = UIKeyboardAppearanceDark;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_userNameText becomeFirstResponder];
}

- (void)RegistAction {
    
    [self.view endEditing:YES];
    
    if ([self AuthText:_userNameText.text] && [self AuthText:_passWordText.text] && [self AuthText:_nickName.text]) {
        
        [AVOSOperate RegisterWithNumber:_userNameText.text passWord:_passWordText.text nickName:_nickName.text];
        
        @weakify(self);
        [RACObserve([LoginManager shareManager], isSendVerifyCode) subscribeNext:^(NSNumber * x) {
            
            @strongify(self);
            
            if ([x boolValue] == YES) {
                
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"ApplicationFirstLaunch"];
                [defaults synchronize];
                
                [self JumpVerify];
            } else {
                
                [self.view shakeView];
            }
        }];
        
    } else {
        
        [self.view shakeView];
    }
}

// @ 跳转到注册界面

- (void)JumpVerify {
    
    [self.navigationController pushViewController:[VerifyViewController new] animated:YES];
}

- (BOOL)AuthText: (NSString *)text {
    
    return text.length > 0 && text != nil && ![text isEqualToString:@""];
}

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    [self.view endEditing:YES];
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

@end
