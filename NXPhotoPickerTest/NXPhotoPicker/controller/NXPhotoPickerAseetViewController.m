//
//  NXPhotoPickerViewController.m
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import "NXPhotoPickerAseetViewController.h"
#import "NXPhotoPickerCollectionView.h"
#import "NXPhotoPickerToolBarView.h"
#import "NXPhotoPickerCollectionViewCell.h"
#import "NXPhotoPickerDatas.h"
#import "NXPhotoPickerGroup.h"
#import "NXPhotoAssets.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOOLBAR_HEIGHT = 44;

@interface NXPhotoPickerAseetViewController ()<NXPhotoPickerColletionViewDelegate,NXPhotoPickerToolBarViewDelegate>
@property (nonatomic, strong) NXPhotoPickerToolBarView *toolBarView; //底部的view
@property (nonatomic, strong) NXPhotoPickerCollectionView *pickerView; //上半部分的选择的collectionview
@property (nonatomic, strong) UIButton *doneBtn; //完成的按钮
@property (nonatomic, strong) UILabel *makeView; //红色标记
@property (nonatomic, strong) UIToolbar *toolBar;  //底部的toolbar
@property (nonatomic, strong) NSMutableArray *assets;  //保存所有的图片
@property (nonatomic, strong) NXPhotoPickerGroup *assetsGroup; //图片库的分组
//保存，预先传进来的，不在本图片库中的图片，有可能很多库包含了同样的图片，所以其他库选中的图片但是不在本库中的图片不处理的话将丢失
// A组（group）中有(a,b,c,d) B组有(a,b,e,f) 当切换库的时候，假如A组中选择了a.b.c.d ,然后切换到B组，因为现在的算法是在本库中有的图片才会标志为选中状态，所以 c，d 不标记，得到的选中结果中也不会有c 和 d
@property (nonatomic, strong) NSArray *arrOtherLibPicWithoutInThisLib;
@end

@implementation NXPhotoPickerAseetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pickerView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.pickerView.arrDataSource.count -1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
}
#pragma mark 代理和数据源
#pragma mark NXPhotoPickerColletionViewDelegate
//选择了图片
- (void)PickerCollectionView:(NXPhotoPickerCollectionView *)collection selectedData:(NSArray *)data {
    self.toolBarView.arrDataSource = [NSMutableArray arrayWithArray:data];
    if (self.arrOtherLibPicWithoutInThisLib.count) {
        [self.toolBarView.arrDataSource addObjectsFromArray:self.arrOtherLibPicWithoutInThisLib]; //加上那些不在此组中的图片
    }
    if(self.toolBarView.arrDataSource.count > 0) {
        self.makeView.text = [NSString stringWithFormat:@"%ld",self.toolBarView.arrDataSource.count];
        self.makeView.hidden = NO;
    } else {
        self.makeView.hidden = YES;
    }
    //把结果传出去
    [self.toolBarView reloadData];
}
//点击，用于放大图片选择
- (void) toolBaView:(NXPhotoPickerToolBarView *)toolBarView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
//删除，点击了cell 中的“x”按钮
- (void) toolBaView:(NXPhotoPickerToolBarView *)toolBarView didDeleteItemAtIndexPath:(NSInteger )index {
    if(index < self.toolBarView.arrDataSource.count) {
        NXPhotoAssets *asset = self.toolBarView.arrDataSource[index];
        asset.selectedCount --;
        [self.toolBarView.arrDataSource removeObjectAtIndex:index];
    }
    //若删除的是其他组的图片
    self.arrOtherLibPicWithoutInThisLib = [self getOutSideAseet:self.pickerView.arrDataSource withPreSelectedAseets:self.toolBarView.arrDataSource];
    self.pickerView.maxSelectedNum = self.maxSelectedNum - self.arrOtherLibPicWithoutInThisLib.count;
    
    if(self.toolBarView.arrDataSource.count > 0) {
        self.makeView.text = [NSString stringWithFormat:@"%ld",self.toolBarView.arrDataSource.count];
        self.makeView.hidden = NO;
    } else {
        self.makeView.hidden = YES;
    }
    [self.pickerView reloadData];
    [self.toolBarView reloadData];
}


#pragma mark private methods
#pragma mark 数据初始化
- (void)initData {
    //初始化    
    [self getImgs];
}
#pragma mark -初始化所有的组
- (void) setupAssets{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }
    
    __block NSMutableArray *assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [[NXPhotoPickerDatas defaultPicker] getGroupPhotosWithGroup:self.assetsGroup finished:^(NSArray *assets) {
        
        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            NXPhotoAssets *zlAsset = [[NXPhotoAssets alloc] init];
            zlAsset.asset = asset;
            [assetsM addObject:zlAsset];
        }];
        weakSelf.pickerView.arrDataSource = assetsM;
        weakSelf.pickerView.arrPreSelectedAssets = [NSArray arrayWithArray:self.arrPreSelected];
        //保存那些上一个组中传进来的但是在此库中没有的数据
        self.arrOtherLibPicWithoutInThisLib = [self getOutSideAseet:self.pickerView.arrDataSource withPreSelectedAseets:self.arrPreSelected];
        [weakSelf.pickerView reloadData];
    }];
}
-(void) getImgs{
    if(self.group) {
        self.assetsGroup = self.group;
        [self setupAssets];
        self.pickerView.maxSelectedNum = self.maxSelectedNum - self.arrOtherLibPicWithoutInThisLib.count;
        [self PickerCollectionView:nil selectedData:nil]; //初始化工具栏
    }
}

#pragma mark 创建UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(TOOLBAR_HEIGHT, TOOLBAR_HEIGHT);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.toolBarView = [[NXPhotoPickerToolBarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 85, TOOLBAR_HEIGHT) collectionViewLayout:flowLayout];
    self.toolBarView.toolBarDelegate = self;
    self.pickerView.photoDelegate = self;
    self.pickerView.selectedModel = self.selectedModel;
    self.pickerView.showOrder = self.showOrder;
    [self.pickerView reloadData];
    [self.toolBar addSubview:self.toolBarView];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.makeView];
//        if ([self.parentViewController isKindOfClass:[NXCloudPhotoParentViewController class]]) {
//        }else
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

#pragma mark makeView 红点标记View
- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-5, 0, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = [UIColor redColor];
//        if (!self.isJoinInFromCloud)
//            [self.view addSubview:makeView];
        self.makeView = makeView;
    }
    return _makeView;
}
#pragma mark -初始化底部ToorBar
- (UIToolbar *)toolBar {
    if(!_toolBar) {
        UIToolbar *toorBar = [[UIToolbar alloc] init];
        //    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:toorBar];
        self.toolBar = toorBar;
        
        toorBar.frame = CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT);
        
        // 左视图 中间距 右视图
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarView];
        UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
        
        toorBar.items = @[leftItem,fiexItem,rightItem];
    }
    return _toolBar;
}

#pragma mark collectionView
- (NXPhotoPickerCollectionView *)pickerView{
    if (!_pickerView) {
        CGFloat cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        /** 底部的高度 */
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2);
        
        NXPhotoPickerCollectionView *collectionView = [[NXPhotoPickerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // 时间置顶
        collectionView.showOrder = NXPhotoPickerShowOrderAsc;
        // 底部的View
        
        collectionView.contentInset = UIEdgeInsetsMake(5, 0,TOOLBAR_HEIGHT, 0);
        
        collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - TOOLBAR_HEIGHT);

        [self.view addSubview:_pickerView = collectionView];
        
    }
    return _pickerView;
}
//返回按钮
- (void)goBack {
    [self.aseetDelegate PickerAseetView:self withResult:self.toolBarView.arrDataSource];
    [self.navigationController popViewControllerAnimated:YES];
}
// 完成操作
- (void)done {
    [self.aseetDelegate PickerAseetView:self DoneWithResult:self.toolBarView.arrDataSource];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- ( NSArray *)getOutSideAseet:(NSArray *)allAseet withPreSelectedAseets:(NSArray *)preSelectedData{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20];
    [arr addObjectsFromArray:preSelectedData];
    for (NXPhotoAssets *temp in preSelectedData) {
        for (NXPhotoAssets *aseet in allAseet) {
            if ([aseet.pathStr isEqualToString:temp.pathStr]) {
                [arr removeObject:temp];
            }
        }
    }
    return arr;
}
@end
