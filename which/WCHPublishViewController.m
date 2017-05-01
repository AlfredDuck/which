//
//  WCHPublishViewController.m
//  which
//
//  Created by alfred on 2017/4/30.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import "WCHPublishViewController.h"
#import "WCHColorManager.h"
#import "VPImageCropperViewController.h"  // 第三方图片裁切工具
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface WCHPublishViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate>
@property (nonatomic, strong) NSString *textMax;  // 最大输入字符串
@property (nonatomic, strong) UIView *picAView;  // A选项容器
@property (nonatomic, strong) UIView *picBView;  // B选项容器
@property (nonatomic, strong) UIImage *imgA;  // A选项的图片
@property (nonatomic, strong) UIImage *imgB;  // B选项的图片
@property (nonatomic, strong) UIImageView *imgViewA;  // A选项的UIImageView
@property (nonatomic, strong) UIImageView *imgViewB;  // B选项的UIImageView
@property (nonatomic) int aOrB;  // 指明当前在选择哪个图片，取值1或2
@end

@implementation WCHPublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"test";
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self createUIParts];
    [self createTextView];
    [self createPicHolder];
}

- (void)viewWillAppear:(BOOL)animated {
    [self keepCenter:_contentTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - 构建UI
- (void)createUIParts
{
    /* 标题栏 */
    UIView *titleBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, 64)];
    titleBarBackground.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBarBackground];
    
    /* 分割线 */
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64-0.5, _screenWidth, 0.5)];
    line.backgroundColor = [WCHColorManager lightGrayLineColor];
    [titleBarBackground addSubview:line];
    
    /* title */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_screenWidth-200)/2, 20, 200, 44)];
    titleLabel.text = @"发起投票";
    titleLabel.textColor = [WCHColorManager mainTextColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBarBackground addSubview:titleLabel];
    
    
    /* 关闭按钮 */
    UIImage *oneImage = [UIImage imageNamed:@"close.png"]; // 使用ImageView通过name找到图片
    UIImageView *oneImageView = [[UIImageView alloc] initWithImage:oneImage]; // 把oneImage添加到oneImageView上
    oneImageView.frame = CGRectMake(14.5, 14.5, 15, 15); // 设置图片位置和大小
    // [oneImageView setContentMode:UIViewContentModeCenter];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backView addSubview:oneImageView];
    // 为UIView添加点击事件
    // 一定要先将userInteractionEnabled置为YES，这样才能响应单击事件
    backView.userInteractionEnabled = YES; // 设置图片可以交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCloseButton)]; // 设置手势
    [backView addGestureRecognizer:singleTap]; // 给图片添加手势
    [titleBarBackground addSubview:backView];
    
    
    // “发送” 按钮
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(_screenWidth - 49-8, 28.5, 49, 27)];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendButton.backgroundColor = [WCHColorManager commonPink];
    _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _sendButton.layer.cornerRadius = 3;
    [_sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
    [titleBarBackground addSubview:_sendButton];
    
}



#pragma mark - 构建输入框
/** 构建输入框 */
- (void)createTextView
{
    // 评论输入框
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 64, _screenWidth-60, 200)];
    // _contentTextView.backgroundColor = [UIColor yellowColor];
    _contentTextView.textColor = [WCHColorManager mainTextColor];
    _contentTextView.textAlignment = NSTextAlignmentCenter;
    _contentTextView.font = [UIFont fontWithName:@"PingFangSC-Thin" size:20];
    _contentTextView.delegate = self;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_contentTextView];
    // 一开始就让光标居中的小技巧:)
    _contentTextView.text = @" ";
    [self keepCenter:_contentTextView];
    _contentTextView.text = @"";
    
    
    // 自定义 UITextView 的 placeholder
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(_screenWidth/2.0-100, 80+64, 200, 40)];
    _placeholder.text = @"点击输入标题";
    _placeholder.textColor = [UIColor lightGrayColor];
    _placeholder.font = [UIFont fontWithName:@"PingFangSC-Thin" size: 20];
    _placeholder.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_placeholder];
}



#pragma mark - UITextView 代理方法
// 内容发生改变
- (void)textViewDidChange:(UITextView *)textView
{
    _placeholder.hidden = YES;
    if ([textView.text isEqualToString:@""]) {
        _placeholder.hidden = NO;
    }
    
    // 超过一定高度就不能输入了
    if ([textView bounds].size.height <= [textView contentSize].height + 20){
        textView.text = _textMax;
    } else {
        _textMax = textView.text;
    }
    
    // 通过偏移来设置垂直居中
    [self keepCenter:textView];
}


- (void)keepCenter:(UITextView *)textView
{
    //    NSLog(@"%f", [textView bounds].size.height);
    //    NSLog(@"%f", [textView contentSize].height);
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height * [textView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    textView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}


// 用回车完成编辑
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//// 隐藏键盘(点击空白处)
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"隐藏键盘");
//    [self.view endEditing:YES];
//}




#pragma mark - 裁切图片(all here)

/** 两张图片容器 */
- (void)createPicHolder
{
    unsigned long ww = _screenWidth/2.0 - 1;
    unsigned long hh = ww/3.0*4.0;
    
    _picAView = [[UIView alloc] initWithFrame:CGRectMake(0, 200+64, ww, hh)];
    _picBView = [[UIView alloc] initWithFrame:CGRectMake(ww+2, 200+64, ww, hh)];
    _picAView.backgroundColor = [WCHColorManager lightGrayBackground];
    _picBView.backgroundColor = [WCHColorManager lightGrayBackground];
    [self.view addSubview: _picAView];
    [self.view addSubview: _picBView];
    _picAView.tag = 1;
    _picBView.tag = 2;
    
    UIImageView *iconA = [[UIImageView alloc] initWithFrame:CGRectMake((ww-61)/2.0, (hh-61)/2.0, 61, 61)];
    iconA.image = [UIImage imageNamed:@"a_icon.png"];
    [_picAView addSubview: iconA];
    UIImageView *iconB = [[UIImageView alloc] initWithFrame:CGRectMake((ww-61)/2.0, (hh-61)/2.0, 61, 61)];
    iconB.image = [UIImage imageNamed:@"b_icon.png"];
    [_picBView addSubview: iconB];
    
    // 为UIView添加点击事件
    UITapGestureRecognizer *singleTapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicHolder:)]; // 设置手势
    UITapGestureRecognizer *singleTapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicHolder:)]; // 设置手势
    _picAView.userInteractionEnabled = YES; // 设置图片可以交互
    _picBView.userInteractionEnabled = YES; // 设置图片可以交互
    [_picAView addGestureRecognizer:singleTapA]; // 给图片添加手势
    [_picBView addGestureRecognizer:singleTapB]; // 给图片添加手势
    
}

/** 展示裁切后的图片 */
- (void)showCutPic:(UIImage *)img
{
    unsigned long ww = _screenWidth/2.0 - 1;
    unsigned long hh = ww/3.0*4.0;
    
    if (_aOrB == 1) {
        _imgViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        // uiimageview居中裁剪
        _imgViewA.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewA.clipsToBounds  = YES;
        _imgViewA.image = img;
        [_picAView addSubview:_imgViewA];

    } else {
        _imgViewB = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ww, hh)];
        // uiimageview居中裁剪
        _imgViewB.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewB.clipsToBounds  = YES;
        _imgViewB.image = img;
        [_picBView addSubview:_imgViewB];
    }
}




#pragma mark - IBAction
- (void)clickCloseButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSendButton
{
    
}

- (void)clickPicHolder:(UIGestureRecognizer *)sender
{
    NSLog(@"clickPicHolder");
    _aOrB = (int)sender.view.tag;
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}




#pragma mark - UIImagePickerControllerDelegate 相册访问代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        CGRect cutFrame = CGRectMake(30, (_screenHeight-(_screenWidth-60)/3.0*4)/2.0, _screenWidth-60, (_screenWidth-60)/3.0*4);
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:cutFrame limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}





#pragma mark - VPImageCropperDelegate 图片裁切工具代理
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    // _imgA = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // 展示裁切后的图片
        [self showCutPic:editedImage];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
















#pragma mark - camera utility(下面这部分不知道为什么需要，是第三方图片裁切工具需要的)
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



@end
