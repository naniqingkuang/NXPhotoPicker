//
//  NXPhotoPickerCollectionView.m
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import "NXPhotoPickerCollectionView.h"
#import "NXPhotoPickerCollectionViewCell.h"
#import "NXPhotoAssets.h"
#import "NXPhotoPickerImageView.h"
#import "NXPhotoPickerFooterCollectionReusableView.h"

static const NSString * myPhotoPickerCollectionViewCellID = @"NXPhotoPickerCollectionViewCellID";
static const NSString *_footerIdentifier = @"_footerIdentifier";

@interface NXPhotoPickerCollectionView()
@property (nonatomic, strong) NXPhotoPickerFooterCollectionReusableView *footerView;
@end

@implementation NXPhotoPickerCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        _arrSelectedAssets = [NSMutableArray array];
        [self registerClass:[NXPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:myPhotoPickerCollectionViewCellID];
        [self registerClass:[NXPhotoPickerFooterCollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier];

    }
    return self;
}
#pragma mark UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self.photoDelegate PickerCollectionView:self selectedData:[self getSelectedAssets]];
    if(self.arrDataSource) {
        return _arrDataSource.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NXPhotoPickerCollectionViewCell *cell = [NXPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath withIndentify:myPhotoPickerCollectionViewCellID];
    if(self.arrDataSource.count > indexPath.row) {
        NXPhotoAssets *asset = self.arrDataSource[indexPath.row];
#pragma mark cell 在单选和多选的时候
        if(NXPhotoPickerSingleSelected == self.selectedModel) {  //单选
            if(asset.selectedCount >1) {
                asset.selectedCount = 1;
            }
        } else {
            
        }
        cell.ImageView.image = asset.thumbImage;
        cell.ImageView.maskViewFlag = YES;
        cell.ImageView.animationRightTick = YES;
        cell.ImageView.count = asset.selectedCount;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
#pragma mark 单选和复选的功能实现
    NXPhotoAssets *asset = self.arrDataSource[indexPath.row];
    if(NXPhotoPickerSingleSelected == self.selectedModel) {  //单选
        [self singleModelDeal:asset];
    } else if(NXPhotoPickerMultableSelected == self.selectedModel) {
        [self multableModelDeal:asset];
    }
    [self reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    [self.photoDelegate PickerCollectionView:self selectedData:[self getSelectedAssets]];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NXPhotoPickerFooterCollectionReusableView *footerView = nil;
   
    if (kind == UICollectionElementKindSectionFooter) {
         footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier forIndexPath:indexPath];
        _footerView = footerView;
        footerView.count = self.arrDataSource.count;
    }
    return footerView;
}
- (void)alertShow:(NSString *)msg {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action];
    [[self viewController] presentViewController:alertVC animated:YES completion:nil];

}
#pragma mark 单选模式
- (void)singleModelDeal:(NXPhotoAssets *)asset {
    if (asset.selectedCount > 0) {
        asset.selectedCount = 0;
    } else if (asset.selectedCount == 0) {
        NSInteger selectedCount = [self selectedCountAssets];
        if(selectedCount >= self.maxSelectedNum) {
            asset.selectedCount = 0;  //超过上限的时候不选中，并且提示用户
            NSString *format = [NSString stringWithFormat:@"亲，你还能选择%ld张图片",_maxSelectedNum - selectedCount];
            [self alertShow:format];
        } else {
            asset.selectedCount = 1;
        }
    }
}
#pragma mark 复选模式
- (void)multableModelDeal:(NXPhotoAssets *)asset {
    NSInteger selectedCount = [self selectedCountAssets];
    if(selectedCount < self.maxSelectedNum) {
        asset.selectedCount ++;
    } else if(selectedCount >= self.maxSelectedNum) {
        if(asset.selectedCount > 0) { //说明选择这张图片是之前已经选过了的
            asset.selectedCount --;
        } else {
            NSString *format = [NSString stringWithFormat:@"亲，你还能选择%ld张图片",_maxSelectedNum - selectedCount];
            [self alertShow:format];
        }
    }
}
#pragma mark private methods
//arrDataSource 的setter 方法
- (void)setArrDataSource:(NSArray *)arrDataSource {
    NXPhotoAssets * temp = nil;
    _arrDataSource = [NSArray arrayWithArray:arrDataSource];
    if(_arrDataSource.count && _arrPreSelectedAssets.count) {
        for (NXPhotoAssets *asset in _arrPreSelectedAssets) {
            for (int  i = 0; i < _arrDataSource.count; i ++) {
                temp = _arrDataSource[i];
                if([temp.pathStr isEqualToString:asset.pathStr]) {
                    if(NXPhotoPickerSingleSelected == _selectedModel) {
                        temp.selectedCount = 1;
                    } else if (NXPhotoPickerMultableSelected == _selectedModel) {
                        temp.selectedCount++;
                    }
                }
            }
        }
        [self.photoDelegate PickerCollectionView:self selectedData:[self getSelectedAssets]];
    }
}
//计算选中的图片的个数，包含多选和单选
- (NSInteger)selectedCountAssets {
    NSInteger count = 0;
    for (NXPhotoAssets *asset in self.arrDataSource) {
        if(asset.selectedCount >0) {
            count += asset.selectedCount;
        }
    }
    return count;
}
//得到视图控制器
- (UIViewController *)viewController {
    UIResponder *responder = self;
    for (responder = self; ;responder = [responder nextResponder] ) {
        if([responder isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return (UIViewController*)responder;
}
//得到选中的图片，单选和多选通用
- (NSArray *)getSelectedAssets {
    [self.arrSelectedAssets removeAllObjects];
    for (NXPhotoAssets *asset in self.arrDataSource) {
        if (asset.selectedCount > 0) {
            for (int i = 0; i < asset.selectedCount; i++) {
                [self.arrSelectedAssets addObject:asset];
            }
        }
    }
    return self.arrSelectedAssets;
}
//PreSelectedAssets setter 方法
- (void)setArrPreSelectedAssets:(NSArray *)arrPreSelectedAssets {
    NXPhotoAssets * temp;
    _arrPreSelectedAssets = [NSArray arrayWithArray:arrPreSelectedAssets];
    if(_arrDataSource.count && _arrPreSelectedAssets.count) {
        for (NXPhotoAssets *asset in _arrPreSelectedAssets) {
            for (int  i = 0; i < _arrDataSource.count; i ++) {
                temp = _arrDataSource[i];
                if([temp.pathStr isEqualToString:asset.pathStr]) {
                    if(NXPhotoPickerSingleSelected == _selectedModel) {
                        temp.selectedCount = 1;
                    } else if (NXPhotoPickerMultableSelected == _selectedModel) {
                        temp.selectedCount++;
                    }
                }
            }
        }
        [self.photoDelegate PickerCollectionView:self selectedData:[self getSelectedAssets]];
    }
}
- (void)setAsset:(NXPhotoAssets *)asset {
    NXPhotoAssets *temp = 0;
    for (NXPhotoAssets *set in _arrDataSource) {
        if([set.pathStr isEqualToString:asset.pathStr]) {
            temp = set;
            break;
        }
    }
    if(temp.selectedCount) {
        temp.selectedCount --;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
