//
//  PickerGroup.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol NXPhotoPickerGroup
@end
@interface NXPhotoPickerGroup : NSObject

/**
 *  组名
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  缩略图
 */
@property (nonatomic , strong) UIImage *thumbImage;

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;

@property (nonatomic , strong) ALAssetsGroup *group;

@end


//#import <UIKit/UIKit.h>
//#import <AssetsLibrary/AssetsLibrary.h>
//
//@interface ZLPhotoPickerGroup : NSObject
//
///**
// *  组名
// */
//@property (nonatomic , copy) NSString *groupName;
//
///**
// *  组的真实名
// */
//@property (nonatomic , copy) NSString *realGroupName;
//
///**
// *  缩略图
// */
//@property (nonatomic , strong) UIImage *thumbImage;
//
///**
// *  组里面的图片个数
// */
//@property (nonatomic , assign) NSInteger assetsCount;
//
///**
// *  类型 : Saved Photos...
// */
//@property (nonatomic , copy) NSString *type;
//
//@property (nonatomic , strong) ALAssetsGroup *group;
//
//@end
