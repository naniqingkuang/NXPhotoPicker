//
//  PickerImageView.m
//  相机
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "NXPhotoPickerImageView.h"

@interface NXPhotoPickerImageView ()

@property (nonatomic , weak) UIView *maskView;
@property (nonatomic , strong) UILabel *lbTick;
@property (nonatomic , weak) UIImageView *videoView;


@end

@implementation NXPhotoPickerImageView

//- (id)initWithFrame:(CGRect)frame cellIndexPath:(NSIndexPath *)indexPath
//{
//    if (self = [super initWithFrame:frame]) {
//        self.contentMode = UIViewContentModeScaleAspectFill;
//        self.clipsToBounds = YES;
//        _indexPath = indexPath;
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.alpha = 0.1;
        maskView.hidden = YES;
//        maskView.userInteractionEnabled = YES;
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    return _maskView;
}

- (UIImageView *)videoView{
    if (!_videoView) {
        UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height - 40, 30, 30)];
        videoView.image = [UIImage imageNamed:@"video"];
        videoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:videoView];
        self.videoView = videoView;
    }
    return _videoView;
}
- (UILabel *)lbTick {
    if(!_lbTick) {
        _lbTick = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 20, 0, 20, 20)];
        [_lbTick.layer setCornerRadius:10];
        [_lbTick setTextColor:[UIColor whiteColor]];
        _lbTick.backgroundColor = [UIColor colorWithRed:0.27 green:0.64 blue:0.19 alpha:1];
        [_lbTick setTextAlignment:NSTextAlignmentCenter];
        [_lbTick.layer setMasksToBounds:YES];
        [self addSubview:_lbTick];
    }
    return _lbTick;
}

- (void)setIsVideoType:(BOOL)isVideoType{
    _isVideoType = isVideoType;
    
    self.videoView.hidden = !(isVideoType);
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag = maskViewFlag;
    self.maskView.hidden = !maskViewFlag;
    self.lbTick.hidden =!maskViewFlag;
}

- (void)setMaskViewColor:(UIColor *)maskViewColor{
    _maskViewColor = maskViewColor;
    
    self.maskView.backgroundColor = maskViewColor;
}

- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha{
    _maskViewAlpha = maskViewAlpha;

    self.maskView.alpha = maskViewAlpha;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick{
    _animationRightTick = animationRightTick;
}
- (void)setCount:(NSInteger )count {
    _count = count;
    if(_count > 0) {
        self.lbTick.text = [NSString stringWithFormat:@"%ld",count];
        self.lbTick.hidden = NO;
    } else {
        self.lbTick.text = @"";
        self.lbTick.hidden = YES;
    }
}



@end
