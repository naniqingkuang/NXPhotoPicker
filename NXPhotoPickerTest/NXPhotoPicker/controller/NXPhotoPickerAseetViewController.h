//
//  NXPhotoPickerViewController.h
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXPhotoPickerCollectionView.h"
#import "NXPhotoPickerGroup.h"
@class NXPhotoPickerAseetViewController;
@protocol NXPhotoPickerAseetViewControllerDelegate
- (void)PickerAseetView:(NXPhotoPickerAseetViewController *)photoPicker withResult:(NSArray *)data;
- (void)PickerAseetView:(NXPhotoPickerAseetViewController *)photoPicker DoneWithResult:(NSArray *)data;
@end
// 状态组
typedef NS_ENUM(NSInteger , PickerViewShowStatus) {
    PickerViewShowStatusGroup = 0, // default groups .
    PickerViewShowStatusCameraRoll ,
    PickerViewShowStatusSavePhotos ,
    PickerViewShowStatusPhotoStream ,
    PickerViewShowStatusVideo,
};
@interface NXPhotoPickerAseetViewController : UIViewController
//排序
@property (nonatomic, assign) NXPhotoPickerShowOrder showOrder; //默认升序排列
//模式设定
@property (nonatomic, assign) NXPhotoPickerSelectedModel selectedModel; //默认单选
//最大的选中数量
@property (nonatomic, assign) NSInteger maxSelectedNum;  //默认9张
//最小的选中数量
@property (nonatomic, assign) NSInteger minSelectedNum;

//是否已藏底部的工具栏
@property (nonatomic, assign) BOOL isHideToolBar; //默认打开为NO
//传入的AssetGroup数组,主要是根据此数组进行数据操作，有多个Group 需要处理则将NXPhotoPickerGroup 类型放入数组中
@property (nonatomic, strong) NXPhotoPickerGroup *group;
//已经选好的图片数组
@property (nonatomic, strong) NSArray *arrPreSelected;
//结果的代理方法
@property (nonatomic, weak) id<NXPhotoPickerAseetViewControllerDelegate> aseetDelegate;
@end
