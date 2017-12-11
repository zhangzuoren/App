//
//  FaceLogin.m
//  App
//
//  Created by zhangzuoren on 2017/11/20.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import "FaceLogin.h"
#import "ViewController.h"
#import "BaseIconLabel.h"
#import <AVFoundation/AVFoundation.h>

@interface FaceLogin ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    BOOL _loading;//校验照片中
    int _count;
}
//硬件设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出流
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;//用于二维码识别以及人脸识别
//输出流(用于截屏)
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
//协调输入输出流的数据
@property (nonatomic, strong) AVCaptureSession *session;
//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong,nonatomic) UIView *container;
@property (strong,nonatomic) BaseIconLabel *noFace;
@property (strong,nonatomic) BaseIconLabel *haveFace;

@property (strong,nonatomic) UIButton *back;
@end

@implementation FaceLogin

#pragma mark - 获取硬件设备
- (AVCaptureDevice *)device{
    if (_device == nil) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionFront) {
                _device=device;
                break;
            }
        }
        
        if ([_device lockForConfiguration:nil]) {   //上锁（调整device属性的时候需要上锁）
            //自动闪光灯
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            //自动曝光
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [_device unlockForConfiguration];//解锁
        }
    }
    return _device;
}

#pragma mark - 获取硬件的输入流
- (AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

#pragma mark - 输出流
- (AVCaptureMetadataOutput *)metadataOutput{
    if (_metadataOutput == nil) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _metadataOutput.rectOfInterest = self.view.bounds;  //设置扫描区域
    }
    return _metadataOutput;
}

#pragma mark - 协调输入和输出数据的会话
- (AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.metadataOutput]) {
            [_session addOutput:self.metadataOutput];
            //设置扫描类型
            //人脸识别
            self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        }
        _stillImageOutput = [AVCaptureStillImageOutput new];
        [_session addOutput:_stillImageOutput];
        _stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    }
    return _session;
}

#pragma mark - 预览图像的层
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = self.container.layer.bounds;
    }
    return _previewLayer;
}
-(UIView *)container{
    if(!_container){
        _container=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _container;
}
-(BaseIconLabel *)noFace{
    if(!_noFace){
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        image.image=[UIImage imageNamed:@"rol_red"];
        _noFace=[BaseIconLabel new];
        _noFace.font=[UIFont systemFontOfSize:14];
        _noFace.textColor=[UIColor whiteColor];
        _noFace.direction = kIconAtLeft;
        _noFace.gap = 5.f;
        _noFace.iconView = image;
        [_noFace sizeToFitWithText:@"未检测到人脸"];
        _noFace.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, 42);
        _noFace.bounds=CGRectMake(0, 0, _noFace.width, _noFace.height);
    }
    return _noFace;
}
-(BaseIconLabel *)haveFace{
    if(!_haveFace){
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        image.image=[UIImage imageNamed:@"rol_blue"];
        _haveFace=[BaseIconLabel new];
        _haveFace.font=[UIFont systemFontOfSize:14];
        _haveFace.textColor=[UIColor whiteColor];
        _haveFace.direction = kIconAtLeft;
        _haveFace.gap = 5.f;
        _haveFace.iconView = image;
        [_haveFace sizeToFitWithText:@"正在识别中，请保持当前姿势"];
        _haveFace.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, 42);
        _haveFace.bounds=CGRectMake(0, 0, _haveFace.width, _haveFace.height);
    }
    return _haveFace;
}
-(UIButton *)back{
    if(!_back){
        _back=[UIButton buttonWithType:UIButtonTypeCustom];
        _back.frame=CGRectMake(16, STATUS_BAR_HEIGHT+4, 16, 16);
        [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_back setBackgroundImage:[UIImage imageNamed:@"back_light"] forState:UIControlStateHighlighted];
        [_back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}
-(void)backClick{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.session stopRunning];
    self.session = nil;
    [self.previewLayer removeFromSuperlayer];
    [super viewWillDisappear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _loading=NO;
    _count=0;
    
    //把previewLayer添加到self.view.layer上
    [self.view addSubview:self.container];
    [self.container.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.noFace];
    [self.view addSubview:self.haveFace];
    self.noFace.hidden=NO;
    self.haveFace.hidden=YES;
}
- (void)dealloc{
    if (_session) {
        [_session stopRunning];
        [_session removeInput:_input];
        _input = nil;
        [_session removeOutput:_metadataOutput];
        [_session removeOutput:_stillImageOutput];
        _metadataOutput = nil;
        _stillImageOutput = nil;
        _session = nil;
        _device = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 切换前后置摄像头
- (void)switchCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"扫描完成 = %zd个 == %@", metadataObjects.count, metadataObjects);
    
    if (metadataObjects.count > 0) {
        self.noFace.hidden=YES;
        self.haveFace.hidden=NO;
        
        if(_count>72 && !_loading){
            _loading=YES;
            AVCaptureConnection *stillConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
            static SystemSoundID soundID = 0;
            if (soundID == 0) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter2" ofType:@"caf"];
                NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
            }
            AudioServicesPlaySystemSound(soundID);
            [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if(error) {
                    NSLog(@"There was a problem");
                    return;
                }
                
                NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                NSMutableArray *data=[[NSMutableArray alloc] initWithObjects:jpegData,nil];
                [MBProgressHUD showMessage:@"识别中"];
                [Http postImagesData:data uploadUrl:[NSString stringWithFormat:@"%@/qdweb/faceLX.jsp",BaseUrl] name:@"wjkfile" parametersDic:nil uploadProgress:nil success:^(id requestObj) {
                    [MBProgressHUD hideHUD];
                    NSLog(@"%@",requestObj);
                    if([requestObj[@"success"] isEqualToString:@"true"]){
                        [[UserInfo sharedUserInfo] setFaceUserInfo:requestObj[@"person"]];
                        [self dismissViewControllerAnimated:NO completion:nil];
                        if(self.block){
                            self.block();
                        }
                    }else{
                        _loading=NO;
                        _count=0;
                        self.noFace.hidden=NO;
                        self.haveFace.hidden=YES;
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                } failure:^(NSError *errorInfo) {
                    [MBProgressHUD hideHUD];
                    _loading=NO;
                    _count=0;
                    self.noFace.hidden=NO;
                    self.haveFace.hidden=YES;
                }];
            }];
        }else{
            _count++;
        }
    }else{
        _loading=NO;
        _count=0;
        self.noFace.hidden=NO;
        self.haveFace.hidden=YES;
    }
}



@end


