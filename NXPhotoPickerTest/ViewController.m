//
//  ViewController.m
//  NXPhotoPickerTest
//
//  Created by HZSD on 16/3/22.
//  Copyright © 2016年 HZSD. All rights reserved.
//

#import "ViewController.h"
#import "NXPhotoPickerAseetViewController.h"
#import "NXPhotoPickerGroupViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonActioin:(id)sender {
    NXPhotoPickerGroupViewController *vc = [[NXPhotoPickerGroupViewController alloc]init];
   // NXPhotoPickerViewController *vc = [[NXPhotoPickerViewController alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
    vc.maxCount = 15;
    vc.model = NXPhotoPickerMultableSelected;
    vc.status = PickerViewShowStatusCameraRoll;
    [self.navigationController pushViewController:vc animated:NO];
}
@end
