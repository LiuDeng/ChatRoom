//
//  VideoRoomListViewController.m
//  ChatRoom
//
//  Created by XueYulun on 15/7/18.
//  Copyright © 2015年 __Dylan. All rights reserved.
//

#import "VideoRoomListViewController.h"

@interface VideoRoomListViewController ()

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (strong, nonatomic) BRFlabbyTableManager *flabbyTableManager;
@property (strong, nonatomic) NSArray *cellColors;
@property (strong, nonatomic) AgoraAudioKit * agoraAudio;

@end

@implementation VideoRoomListViewController

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PresentSettingButton:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"VideoRoomPushSetting" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
