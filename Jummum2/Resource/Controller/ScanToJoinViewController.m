//
//  ScanToJoinViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ScanToJoinViewController.h"
#import "Message.h"

@interface ScanToJoinViewController ()
{
    BOOL _alreadyDetect;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


-(BOOL)startReading;
-(void)stopReading;
@end

@implementation ScanToJoinViewController

@synthesize lblNavTitle;
@synthesize topViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    
    [self stopReading];
    dispatch_async(dispatch_get_main_queue(), ^
   {
       [self startReading];
   });
    

    //Get Preview Layer connection
    AVCaptureConnection *previewLayerConnection=_videoPreviewLayer.connection;

    if ([previewLayerConnection isVideoOrientationSupported])
    {
        [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSString *title = [Language getText:@"สแกน QR Code เพื่อร่วมสั่งอาหาร"];
    lblNavTitle.text = title;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _captureSession = nil;
    [self loadBeepSound];
}

-(void)loadBeepSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

-(BOOL)startReading
{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_vwPreview.layer.bounds];
    [_vwPreview.layer addSublayer:_videoPreviewLayer];
    
    _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    [_captureSession startRunning];
    
    
    return YES;
}

-(void)stopReading
{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects && [metadataObjects count] > 0 && !_alreadyDetect)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {      
            NSString *decryptedMessage = [metadataObj stringValue];

            
            _alreadyDetect = YES;
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            [self loadingOverlayView];
            [self.homeModel insertItems:dbOrderJoiningScanQr withData:@[decryptedMessage,@(userAccount.userAccountID)] actionScreen:@"insert order joining in scan to join screen"];
        }
    }
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *orderJoiningList = items[0];
    NSMutableArray *messageList = items[1];
    if([messageList count]>0)
    {
        Message *message = messageList[0];
        [self showAlert:@"" message:message.text method:@selector(setAlreadyDetectToNo)];
    }
    else
    {
        if([orderJoiningList count] > 0)
        {
            [self goBack:nil];
        }
        else
        {
            [self showAlert:@"" message:[Language getText:@"QR Code สำหรับร่วมสั่งอาหารไม่ถูกต้อง"] method:@selector(setAlreadyDetectToNo)];
        }
    }  
}

-(void)setAlreadyDetectToNo
{
    _alreadyDetect = NO;
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToJoinOrder" sender:self];
}

- (IBAction)chooseFromExistingPhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self presentViewController: controller animated: YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    [picker dismissViewControllerAnimated:NO completion:^{
        UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                           context:nil
                           options:@{CIDetectorTracking: @YES,
                                     CIDetectorAccuracy: CIDetectorAccuracyLow}];
        NSString *qrCodeText = @"";
        NSArray *arrFeature = [detector featuresInImage:ciImage];
        for(CIQRCodeFeature *item in arrFeature)
        {
            qrCodeText = [NSString stringWithFormat:@"%@%@",qrCodeText,item.messageString];
        }
        
        //scan qrcode
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        [self loadingOverlayView];
        [self.homeModel insertItems:dbOrderJoiningScanQr withData:@[qrCodeText,@(userAccount.userAccountID)] actionScreen:@"insert order joining in scan to join screen"];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}
@end
