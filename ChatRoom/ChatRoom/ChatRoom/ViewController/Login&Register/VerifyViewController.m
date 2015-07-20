//
//  VerifyViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/19.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "VerifyViewController.h"

@interface VerifyViewController ()

@property (nonatomic, strong) UITextField * verifyCodeText;
@property (nonatomic, strong) UIButton * skipButton;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Verify Number";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Verify !" style:UIBarButtonItemStylePlain target:self action:@selector(verifyAction)];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    /**< White Area */
    
    UIView * whiteArea = [[UIView alloc] initWithFrame:CGRectMake(12, 20, [UIScreen mainScreen].bounds.size.width - 24, 40)];
    whiteArea.backgroundColor = [UIColor whiteColor];
    whiteArea.layer.masksToBounds = YES;
    whiteArea.layer.cornerRadius = 4;
    [self.view addSubview:whiteArea];
    
    _verifyCodeText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(whiteArea.frame), 40)];
    _verifyCodeText.layer.cornerRadius = 4;
    _verifyCodeText.layer.masksToBounds = YES;
    _verifyCodeText.placeholder = @"Verify Code, Ckeck sms";
    _verifyCodeText.textColor = [UIColor primaryBackgroundColor];
    _verifyCodeText.font = [UIFont systemFontOfSize:14.];
    [whiteArea addSubview:_verifyCodeText];
    
    _verifyCodeText.textAlignment = NSTextAlignmentCenter;
    _verifyCodeText.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeText.tintColor = [UIColor primaryBackgroundColor];
    _verifyCodeText.keyboardAppearance = UIKeyboardAppearanceDark;
    
    _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_verifyCodeText.frame), CGRectGetMaxY(whiteArea.frame) + 12, 200, 30)];
    [_skipButton setTitle:@"Skip This Step." forState:UIControlStateNormal];
    [_skipButton setTitleColor:[UIColor defaultTextColor] forState:UIControlStateNormal];
    _skipButton.hidden = YES;
    [_skipButton addTarget:self action:@selector(SkipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipButton];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_verifyCodeText becomeFirstResponder];
}

- (void)verifyAction {
    
    [self.view endEditing:YES];
    
    if ([self AuthText:_verifyCodeText.text]) {
        
        [AVOSOperate VerifyNumber:_verifyCodeText.text];
        
        [RACObserve([LoginManager shareManager], VerifySucceed) subscribeNext:^(NSNumber * x) {
            
            if ([x boolValue] == YES) {
                
                [RKDropdownAlert title:@"Verify Succeed!" backgroundColor:[UIColor secondaryBackgroundColor] textColor:[UIColor whiteColor]];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                
                [self.view shakeView];
                _skipButton.hidden = NO;
            }
        }];
        
    } else {
        
        [self.view shakeView];
        _skipButton.hidden = NO;
    }
}

- (void)SkipAction {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
