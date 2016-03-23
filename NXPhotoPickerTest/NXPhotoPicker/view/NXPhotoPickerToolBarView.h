//
//  NXPhotoPickerToolView.h
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NXPhotoPickerToolBarView;
//协议
@protocol NXPhotoPickerToolBarViewDelegate
//选择
- (void) toolBaView:(NXPhotoPickerToolBarView *)toolBarView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//删除，点击了cell 中的“x”按钮
- (void) toolBaView:(NXPhotoPickerToolBarView *)toolBarView didDeleteItemAtIndexPath:(NSInteger )index;

@end


@interface NXPhotoPickerToolBarView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>
//NXPhotoPickerView 传入的数据,数据源
@property (nonatomic, strong) NSMutableArray *arrDataSource;
//代理
@property (nonatomic, weak) id<NXPhotoPickerToolBarViewDelegate> toolBarDelegate;
@end
