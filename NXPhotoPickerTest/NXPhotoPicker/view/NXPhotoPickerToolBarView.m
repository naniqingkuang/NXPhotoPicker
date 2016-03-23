//
//  NXPhotoPickerToolView.m
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import "NXPhotoPickerToolBarView.h"
#import "NXPhotoPickerToolBarThumbCollectionViewCell.h"
#import "NXPhotoAssets.h"
static NSString *const _identifier = @"toolBarThumbCollectionViewCell";

@implementation NXPhotoPickerToolBarView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UINib nibWithNibName:@"NXPhotoPickerToolBarThumbCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellWithReuseIdentifier:_identifier];
    }
    return self;
}


#pragma mark 代理 和 datasource
#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrDataSource.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NXPhotoPickerToolBarThumbCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
    if(self.arrDataSource.count > indexPath.row) {
        if ([self.arrDataSource[indexPath.row] isKindOfClass:[NXPhotoAssets class]]) {
            cell.imageView.image = [self.arrDataSource[indexPath.item] thumbImage];
        }else if ([self.arrDataSource[indexPath.item] isKindOfClass:[UIImage class]]){
            cell.imageView.image = (UIImage *)self.arrDataSource[indexPath.item];
        }
        cell.index = indexPath.row;
        //删除的处理方法
        __weak typeof(cell) weakCell = cell;
        cell.deleteBlock = ^(NSInteger num) {
            if (self.toolBarDelegate) {
                [_toolBarDelegate toolBaView:self didDeleteItemAtIndexPath:weakCell.index];
                [self reloadData];
            }
        };
    }
    return cell;
}


#pragma mark UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_toolBarDelegate) {
        [_toolBarDelegate toolBaView:self didSelectItemAtIndexPath:indexPath];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)setArrDataSource:(NSMutableArray *)arrDataSource {
//    _arrDataSource = arrDataSource;
//}
@end
