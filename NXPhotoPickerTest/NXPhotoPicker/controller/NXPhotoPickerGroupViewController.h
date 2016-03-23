//
//  ZLPhotoPickerGroupViewController.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXPhotoPickerAseetViewController.h"

@protocol NXPhotoPickerViewControllerDelegate <NSObject>
/**
 *  返回所有的Asstes对象
 */
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets;
/**
 *  点击拍照
 */
- (void)pickerCollectionViewSelectCamera:(NXPhotoPickerAseetViewController *)pickerVc;
@end


@interface NXPhotoPickerGroupViewController : UIViewController

@property (nonatomic , weak) id<NXPhotoPickerViewControllerDelegate> delegate;
//用于第一次进去显示的图片组
@property (nonatomic , assign) PickerViewShowStatus status;
//最大值
@property (nonatomic , assign) NSInteger minCount;
//最小值
@property (nonatomic, assign) NSInteger maxCount;
// 记录选中的值
@property (strong,nonatomic) NSArray *selectAsstes;
// 置顶展示图片
@property (assign,nonatomic) BOOL topShowPhotoPicker;
//模式设定
@property (assign, nonatomic) NXPhotoPickerSelectedModel model;
//排列顺序
@property (assign, nonatomic) NXPhotoPickerShowOrder order;

@end
