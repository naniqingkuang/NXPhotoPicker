//
//  ZLAssets.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-3.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NXPhotoAssets : NSObject

@property (strong,nonatomic) ALAsset *asset;

/**
 *  缩略图
 */
- (UIImage *)aspectRatioImage;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  原图
 */
- (UIImage *)originImage;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;
/**
 *  获取图片的URL
 */
- (NSURL *)assetURL;

//add by lmz
/**
 *  记录被选择的次数
 */
@property (nonatomic, assign) NSInteger selectedCount;

//url 转成文件路径
- (NSString *)pathStr;
@end
