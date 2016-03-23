//
//  NXPhotoPickerGroupViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#define CELL_ROW 4
#define CELL_MARGIN 5
#define CELL_LINE_MARGIN 5


#import "NXPhotoPickerGroupViewController.h"
#import "NXPhotoPickerCollectionView.h"
#import "NXPhotoPickerDatas.h"
#import "NXPhotoPickerGroupViewController.h"
#import "NXPhotoPickerGroup.h"
#import "NXPhotoPickerGroupTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface NXPhotoPickerGroupViewController () <UITableViewDataSource,UITableViewDelegate, NXPhotoPickerAseetViewControllerDelegate>
@property (nonatomic, weak) NXPhotoPickerAseetViewController *collectionVc;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *arrResult;
@end

@implementation NXPhotoPickerGroupViewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
    
    // 设置按钮
    [self setupButtons];
    
    // 获取图片
    [self getImgs];
    
    self.title = @"选择相册";
    
}

- (void) setupButtons{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NXPhotoPickerGroupTableViewCell *cell = [NXPhotoPickerGroupTableViewCell instanceCell];
    cell.group = self.groups[indexPath.row];
    return cell;
}

#pragma mark 跳转到控制器里面的内容
- (void) jump2StatusVc{
    // 如果是相册
    NXPhotoPickerGroup *gp = nil;
    for (NXPhotoPickerGroup *group in self.groups) {
        if ((self.status == PickerViewShowStatusCameraRoll || self.status == PickerViewShowStatusVideo) && ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"])) {
            gp = group;
            break;
        }else if (self.status == PickerViewShowStatusSavePhotos && ([group.groupName isEqualToString:@"Saved Photos"] || [group.groupName isEqualToString:@"保存相册"])){
            gp = group;
            break;
        }else if (self.status == PickerViewShowStatusPhotoStream &&  ([group.groupName isEqualToString:@"Stream"] || [group.groupName isEqualToString:@"我的照片流"])){
            gp = group;
            break;
        }
    }
    if (!gp) return ;
    
    NXPhotoPickerAseetViewController *assetsVc = [[NXPhotoPickerAseetViewController alloc] init];
    assetsVc.selectedModel = self.model;
    assetsVc.showOrder = self.order;
    assetsVc.minSelectedNum = self.minCount;
    assetsVc.maxSelectedNum = self.maxCount;
    assetsVc.group = gp;
    assetsVc.arrPreSelected = [NSArray arrayWithArray:self.arrResult];
    assetsVc.aseetDelegate = self;
    [self.navigationController pushViewController:assetsVc animated:YES];
}
#pragma mark Delegate and datasource
#pragma mark -<UITableViewDelegate>
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NXPhotoPickerGroup *group = self.groups[indexPath.row];
    NXPhotoPickerAseetViewController *assetsVc = [[NXPhotoPickerAseetViewController alloc] init];
    assetsVc.selectedModel = self.model;
    assetsVc.showOrder = self.order;
    assetsVc.minSelectedNum = self.minCount;
    assetsVc.maxSelectedNum = self.maxCount;
    assetsVc.group = group;
    assetsVc.aseetDelegate = self;
    assetsVc.arrPreSelected = [NSArray arrayWithArray:self.arrResult];
    [self.navigationController pushViewController:assetsVc animated:YES];
}
#pragma mark pickerAseetViewControllerDelegate
- (void)PickerAseetView:(NXPhotoPickerAseetViewController *)photoPicker withResult:(NSArray *)data {
    self.arrResult = [NSArray arrayWithArray:data];
}
- (void)PickerAseetView:(NXPhotoPickerAseetViewController *)photoPicker DoneWithResult:(NSArray *)data {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -<Images Datas>

-(void)getImgs{
    NXPhotoPickerDatas *datas = [NXPhotoPickerDatas defaultPicker];
    __weak typeof(self) weakSelf = self;
    if (self.status == PickerViewShowStatusVideo){
        // 获取所有的图片URLs
        [datas getAllGroupWithVideos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
        }];
        
    }else{
        // 获取所有的图片URLs
        [datas getAllGroupWithPhotos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
        }];
    }
}


#pragma mark -<Navigation Actions>
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark private methods
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.tableFooterView = [UIView new];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        
        NSString *heightVfl = @"V:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
        NSString *widthVfl = @"H:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
    }
    return _tableView;
}

@end
