//
//  QRCodeScanTableViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "QRCodeScanTableViewController.h"
#import "MenuSelectionViewController.h"
#import "Utility.h"
#import "Branch.h"
#import "CustomerTable.h"


@interface QRCodeScanTableViewController ()
{
    Branch *_selectedBranch;
    CustomerTable *_selectedCustomerTable;
}
//@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


-(BOOL)startReading;
-(void)stopReading;
@end

@implementation QRCodeScanTableViewController
@synthesize fromCreditCardAndOrderSummaryMenu;
@synthesize customerTable;
@synthesize btnBack;


-(IBAction)unwindToQRCodeScanTable:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    btnBack.hidden = fromCreditCardAndOrderSummaryMenu?NO:YES;
    _captureSession = nil;
    [self loadBeepSound];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self startButtonClicked];
    
    
    //Get Preview Layer connection
    AVCaptureConnection *previewLayerConnection=_videoPreviewLayer.connection;
    
    if ([previewLayerConnection isVideoOrientationSupported])
        [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
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

-(void)startButtonClicked
{
    [self startReading];
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
    //    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
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
    
    if (metadataObjects && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString *decryptedMessage = [metadataObj stringValue];
            NSData *data = [Utility dataFromHexString:decryptedMessage];
            NSString *strMessage = [Utility decryptData:data withKey:[Utility key]];
            
            NSArray *dataList = [strMessage componentsSeparatedByString: @","];
            NSString *branchPart = dataList[0];
            NSString *customerTablePart = dataList[1];
            NSArray *branchPartList = [branchPart componentsSeparatedByString: @":"];
            _selectedBranch = [Branch getBranch:[branchPartList[1] integerValue]];
            NSArray *customerTablePartList = [customerTablePart componentsSeparatedByString: @":"];
            _selectedCustomerTable = [CustomerTable getCustomerTable:[customerTablePartList[1] integerValue] branchID:_selectedBranch.branchID];
            
            
            if(!_selectedBranch || !_selectedCustomerTable)
            {
                [self showAlert:@"" message:@"QR Code ไม่ถูกต้อง"];
            }
            else
            {
                [self stopReading];
                if(fromCreditCardAndOrderSummaryMenu)
                {
                    customerTable = _selectedCustomerTable;
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                       [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
                    });                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
                    });
                }
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.branch = _selectedBranch;
        vc.customerTable = _selectedCustomerTable;
    }
}

@end
