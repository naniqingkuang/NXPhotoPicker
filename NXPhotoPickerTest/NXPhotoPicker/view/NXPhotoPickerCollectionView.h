//
//  NXPhotoPickerCollectionView.h
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXPhotoAssets.h"
typedef NS_ENUM(NSInteger, NXPhotoPickerShowOrder) {   //排序
    NXPhotoPickerShowOrderDesc, //降序
    NXPhotoPickerShowOrderAsc    //升序
};
typedef NS_ENUM(NSInteger, NXPhotoPickerSelectedModel) {  //模式
    NXPhotoPickerSingleSelected,  //单选模式，一张图片只能被一次选中
    NXPhotoPickerMultableSelected  //复选模式，一种图片可以被多次选中
};
@class NXPhotoPickerCollectionView;
@protocol NXPhotoPickerColletionViewDelegate
- (void)PickerCollectionView:(NXPhotoPickerCollectionView *)collection selectedData:(NSArray *)data;
@end
@interface NXPhotoPickerCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>
#pragma mark 定义属性
// 数据源
@property (nonatomic, strong) NSArray *arrDataSource;
//选中的数据
@property (nonatomic, strong, readonly) NSMutableArray *arrSelectedAssets;
//外面传进来的已经选好的图片
@property (nonatomic, strong) NSArray *arrPreSelectedAssets;
//排序
@property (nonatomic, assign) NXPhotoPickerShowOrder showOrder;
//模式设定
@property (nonatomic, assign) NXPhotoPickerSelectedModel selectedModel;
//最大的选中数量
@property (nonatomic, assign) NSInteger maxSelectedNum;
//取消选中的图片
@property (nonatomic, assign) NXPhotoAssets *asset;
//代理
@property (nonatomic, weak) id<NXPhotoPickerColletionViewDelegate> photoDelegate;
@end
