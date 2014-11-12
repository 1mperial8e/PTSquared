//
//  PTScanMembershipViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTScanMembershipViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PTScanMembershipViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) NSMutableString *mCode;

@property (strong, nonatomic) NSArray *metadataObjectTypes;

@end

@implementation PTScanMembershipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    [self setupCaptureSession];
    [self setCameraFlashMode:AVCaptureTorchModeOn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.captureSession isRunning] == NO)
        [self.captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.captureSession isRunning])
        [self.captureSession stopRunning];
}


#pragma mark - Private

- (void)setupCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc]init];
    
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    } else {
        NSLog(@"Could not add video input: %@", [error localizedDescription]);
    }
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    if ([self.captureSession canAddOutput:metadataOutput]) {
        [self.captureSession addOutput:metadataOutput];
        [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [metadataOutput setMetadataObjectTypes:self.metadataObjectTypes];
    } else {
        NSLog(@"Could not add metadata output.");
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:previewLayer];
    
    [self.captureSession startRunning];
}

- (void)codeRecognized
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Code" message:self.mCode delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)setCameraFlashMode:(NSInteger )mode
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode:mode];
        [device unlockForConfiguration];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.mCode == nil) {
        self.mCode = [[NSMutableString alloc] initWithString:@""];
    }
    
    [self.mCode setString:@""];
    
    for (AVMetadataObject *metadataObject in metadataObjects) {
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        [self.mCode appendFormat:@"%@", readableObject.stringValue];
    }
    
    if (![self.mCode isEqualToString:@""]) {
        [self codeRecognized];
        [self.captureSession stopRunning];
    }
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.captureSession startRunning];
}

@end
