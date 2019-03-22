//
//  SubLBXScanViewController.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanViewController.h"

#pragma mark -模仿qq界面
//继承LBXScanViewController,在界面上绘制想要的按钮，提示语等
@interface QQLBXScanViewController : LBXScanViewController

/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

//是否显示调节焦距功能
@property (nonatomic, assign) BOOL isVideoZoom;

//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;

@end
