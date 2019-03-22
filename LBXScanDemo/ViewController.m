//
//  ViewController.m
//  LBXScanDemo
//
//  Created by Mac on 2019/3/21.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "ViewController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"

#import "LBXScanViewStyle.h"
#import "DIYScanViewController.h"
#import "QQLBXScanViewController.h"
#import "CreateBarCodeViewController.h"
#import "StyleDIY.h"
#import "Global.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LBXScanViewControllerDelegate>
{
    NSString * qrResult;
}
@property (nonatomic, strong) NSArray<NSArray*>* arrayItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo展示";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self arrayItems];
}

- (NSArray*)arrayItems
{
    if (!_arrayItems) {
        
        //界面DIY list
        NSArray *array1 = @[
                            @[@"模拟qq扫码界面",@"qqStyle"],
                            @[@"模仿支付宝扫码区域",@"ZhiFuBaoStyle"],
                            @[@"模仿微信扫码区域",@"weixinStyle"],
                            @[@"无边框，内嵌4个角",@"InnerStyle"],
                            @[@"4个角在矩形框线上,网格动画",@"OnStyle"],
                            @[@"自定义颜色",@"changeColor"],
                            @[@"只识别框内",@"recoCropRect"],
                            @[@"改变尺寸",@"changeSize"],
                            @[@"条形码效果",@"notSquare"]
                            ];
        
        //条码生成
        NSArray *array2 = @[@[@"二维码/条形码生成",@"createBarCode"]
                            ];
        
        //识别图片
        NSArray *array3 = @[
                            @[@"相册",@"openLocalPhotoAlbum"]
                            ];
        
        _arrayItems = @[array1,array2,array3];
    }
    return _arrayItems;
}

- (void)showError:(NSString*)str
{
    NSLog(@"%@",str);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return _arrayItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    NSArray *item = _arrayItems[section];
    return item.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* strTitle = @"title";
    switch (section) {
        case 0:
            strTitle = @"  DIY界面效果";
            break;
        case 1:
            strTitle = @"  条码生成";
            break;
        case 2:
            strTitle = @"  条码图片识别";
            break;
        default:
            break;
    }
    return strTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_arrayItems[indexPath.section][indexPath.row]firstObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf startWithIndexPath:indexPath];
        }
        else if(!firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
        }
    }];
}

- (void)startWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray* array = _arrayItems[indexPath.section][indexPath.row];
    NSString *methodName = array.lastObject;
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:normalSelector]) {
        [self performSelector:normalSelector];
    }
}

#pragma mark ---自定义界面

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    DIYScanViewController *vc = [DIYScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -模仿qq界面
- (void)qqStyle
{
    //添加一些扫码或相册结果处理
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    
    vc.style = [StyleDIY qqStyle];
    //    vc.isOpenInterestRect = YES;
    //镜头拉远拉近功能
    vc.isVideoZoom = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --模仿支付宝
- (void)ZhiFuBaoStyle
{
    [self openScanVCWithStyle:[StyleDIY ZhiFuBaoStyle]];
}

#pragma mark -无边框，内嵌4个角
- (void)InnerStyle
{
    [self openScanVCWithStyle:[StyleDIY InnerStyle]];
}

#pragma mark -无边框，内嵌4个角
- (void)weixinStyle
{
    [self openScanVCWithStyle:[StyleDIY weixinStyle]];
}

#pragma mark -框内区域识别
- (void)recoCropRect
{
    DIYScanViewController *vc = [DIYScanViewController new];
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    
    vc.style = [StyleDIY recoCropRect];
    //开启只识别框内
    vc.isOpenInterestRect = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -4个角在矩形框线上,网格动画
- (void)OnStyle
{
    [self openScanVCWithStyle:[StyleDIY OnStyle]];
}

#pragma mark -自定义4个角及矩形框颜色
- (void)changeColor
{
    DIYScanViewController *vc = [DIYScanViewController new];
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    
    vc.style = [StyleDIY changeColor];
    
    //开启只识别矩形框内图像功能
    vc.isOpenInterestRect = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -改变扫码区域位置
- (void)changeSize
{
    [self openScanVCWithStyle:[StyleDIY changeSize]];
}

#pragma mark -非正方形，可以用在扫码条形码界面
- (void)notSquare
{
    [self openScanVCWithStyle:[StyleDIY notSquare]];
}

#pragma mark --生成条码

- (void)createBarCode
{
    if ([Global sharedManager].libraryType == SLT_ZBar) {
        
        [self showError:@"ZBar不支持生成条码"];
        return;
    }
    CreateBarCodeViewController *vc = [[CreateBarCodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 相册
- (void)openLocalPhotoAlbum
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //部分机型可能导致崩溃
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        //ios8.0之后支持
        __weak __typeof(self) weakSelf = self;
        [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
    }
    else
    {
        [self showError:@"native低于ios8.0不支持识别图片"];
    }
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self showError:@"识别失败了"];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    if (!array[0].strScanned || [array[0].strScanned isEqualToString:@""] ) {
        
        [self showError:@"识别失败了"];
        return;
    }
    LBXScanResult *scanResult = array[0];
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    qrResult = strResult.strScanned;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:qrResult delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"前往浏览器",@"复制文本",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //确定
    }else if (buttonIndex == 1){
        //浏览器
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qrResult]];
        
    }else if (buttonIndex == 2){
        //复制
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = qrResult;
    }
}

@end
