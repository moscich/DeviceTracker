//
//  ViewController.h
//  DeviceTracker
//
//  Created by Marek Mościchowski on 19/05/15.
//  Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <AVFoundation/AVFoundation.h>

@class GPPSignIn;
@class AFHTTPSessionManager;

@interface ViewController : UIViewController <GPPSignInDelegate, NSXMLParserDelegate, AVCaptureMetadataOutputObjectsDelegate>


@property(nonatomic, strong) GPPSignIn *googleSignIn;
@property(nonatomic, strong) IBOutlet UITextField *textField;

@property(nonatomic, strong) NSXMLParser *parser;

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property(nonatomic, strong) NSMutableDictionary *deviceNumbers;
@property(nonatomic, strong) NSMutableDictionary *deviceNames;

@property(nonatomic, strong) NSMutableArray *devices;

@property(nonatomic, copy) NSString *value;

@property(nonatomic, strong) id name;

@property(nonatomic, strong) AVCaptureSession *captureSession;

@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

- (IBAction)signIn;

- (void)super:(int)number;

- (IBAction)qr;
@end

