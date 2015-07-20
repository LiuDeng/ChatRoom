//
//  VoiceRoomListViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/18.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "VoiceRoomListViewController.h"

@interface VoiceRoomListViewController () <AgoraManageDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (strong, nonatomic) BRFlabbyTableManager *flabbyTableManager;
@property (strong, nonatomic) NSArray *cellColors;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) AVObject * currentUser;
@property (nonatomic, assign) BOOL session;
@property (nonatomic, strong) NSString * channelName;
@property (nonatomic, strong) AgoraManager * manager;

@end

@implementation VoiceRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellColors = @[[UIColor colorWithRed:27.0f/255.0f green:27.0f/255.0f blue:40.0f/255.0f alpha:1.0f],
                    [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:50.0f/255.0f alpha:1.0f],
                    ];
    
    _flabbyTableManager = [[BRFlabbyTableManager alloc] initWithTableView:_tableView];
    [_flabbyTableManager setDelegate:self];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BRFlabbyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor primaryBackgroundColor];
    
    _searchBar.delegate = self;
    _searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    _searchBar.returnKeyType = UIReturnKeyJoin;
    _searchBar.tintColor = [UIColor darkGrayColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"No Session" style:UIBarButtonItemStylePlain target:self action:@selector(NoSession)];
    
    _manager = [AgoraManager shareAgora];
    _manager.delegate = self;
}

- (void)NoSession {
    
    if (YES == _session) {
        
        // 当前有会话
        [_manager LeaveChannel:_channelName];
    } else {
        
        // 当前没回话
        [_searchBar becomeFirstResponder];
    }
}

- (void)searchBarTextDidBeginEditing:(nonnull UISearchBar *)searchBar {
    
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(nonnull UISearchBar *)searchBar {
    
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(nonnull UISearchBar *)searchBar {
    
    // Join Chat Action
    [self.view endEditing:YES];
    
    if (![searchBar.text isEqualToString:@""] && searchBar.text != nil && searchBar.text.length > 0) {
     
        // 1. 搜索是否存在这个用户
        AVQuery * query = [AVQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:searchBar.text];
        
        @weakify(self);
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
           
            @strongify(self);
            if (objects.count != 0) {
                
                // 2. 进入语音频道
                NSString * channelName = [NSString stringWithFormat:@"%@%@%@", [AVUser currentUser].username, searchBar.text, [AVUser currentUser].username];
                self.channelName = channelName;
                
                [_manager JoinChannel:channelName];
                
                // 3. 得到用户
                self.currentUser = [objects firstObject];
            } else {
                
                [RKDropdownAlert title:@"Can't find this user!" backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
                
            }
        }];
    }
}

// @ 声网代理方法
- (void)agoreManager:(AgoraManager *)manager APILoadError:(AgoraAudioErrorCode)errorCode {
    
    [RKDropdownAlert title:@"Join Channel Failure, Retry" backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
}

- (void)agoreManager:(AgoraManager *)manager LoggerUid:(NSUInteger)uid Delay:(NSUInteger)dalay allPack:(NSUInteger)allPack lost:(NSUInteger)lostPack {
    
    NSLog(@"Initialized SDK Success");
}

- (void)agoreManager:(AgoraManager *)manager JoinChannel:(BOOL)result ChannelName:(NSString *)channelName userID:(NSInteger)uid {
    
    if (result) {
        
        // 发送推送信息
        AVQuery * pushQuery = [AVInstallation query];
        [pushQuery whereKey:@"number" equalTo:[_currentUser objectForKey:@"username"]];
        
        AVPush * push = [[AVPush alloc] init];
        [push setQuery:pushQuery];
        [push setMessage:self.channelName];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                [RKDropdownAlert title:@"Waiting your friend join..." backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
                self.navigationItem.leftBarButtonItem.title = @"Waiting...";
            } else {
                
                [RKDropdownAlert title:@"please Retry!" backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
            }
        }];
    } else {
        
        [RKDropdownAlert title:@"Join Channel Failure, Retry" backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
    }
}

- (void)agoreManager:(AgoraManager *)manager EnterUser:(NSInteger)uid {
    
    [RKDropdownAlert title:@"Begin Voice Chat !" backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
    self.navigationItem.leftBarButtonItem.title = @"End Session";
    _session = YES;
}

- (void)agoreManager:(AgoraManager *)manager LeaveUser:(NSInteger)uid {
    
    [RKDropdownAlert title:@"Your Friend Quit" backgroundColor:[UIColor primaryBackgroundColor] textColor:[UIColor defaultTextColor]];
    self.navigationItem.leftBarButtonItem.title = @"No Session";
    _session = NO;
}

- (void)searchBarCancelButtonClicked:(nonnull UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)PressSettingButton:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"VoiceRoomPushSetting" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

// @ 列表代理方法

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BRFlabbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setFlabby:YES];
    [cell setLongPressAnimated:YES];
    [cell setFlabbyColor:[self colorForIndexPath:indexPath]];
    
    cell.headImage.image = [UIImage imageNamed:@"avatar"];
    cell.NickLabel.text = @"Dylan Custom Ser3ice";
    cell.Description.text = @"Lazy Boy, Without personal Description";
    cell.TimeLabel.text = @"4 天前";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
}

#pragma mark - BRFlabbyTableManagerDelegate methods

- (UIColor *)flabbyTableManager:(BRFlabbyTableManager *)tableManager flabbyColorForIndexPath:(NSIndexPath *)indexPath{
    return [self colorForIndexPath:indexPath];
}

#pragma mark - Miscellenanious

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    
    return row % 2 == 0 ? _cellColors[0] : _cellColors[1];
}

@end
