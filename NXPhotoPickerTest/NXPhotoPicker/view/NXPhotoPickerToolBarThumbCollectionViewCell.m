//
//  ZLPhotoPickerFootCollectionVewCellCollectionViewCell.m
//  NaXin
//
//  Created by HZSD on 16/3/21.
//  Copyright © 2016年 hzsd. All rights reserved.
//

#import "NXPhotoPickerToolBarThumbCollectionViewCell.h"
@interface NXPhotoPickerToolBarThumbCollectionViewCell()
@property (weak, nonatomic)IBOutlet UIButton *cancelButton;
@end
@implementation NXPhotoPickerToolBarThumbCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    if(self) {
        [self.cancelButton.layer setCornerRadius:self.cancelButton.frame.size.width/2];;
        [self.cancelButton.layer setMasksToBounds:YES];
    }
}
- (IBAction)cancalButtonAciont:(UIButton *)sender {
    if(self.deleteBlock) {
        self.deleteBlock(_index);
    }
}

@end
