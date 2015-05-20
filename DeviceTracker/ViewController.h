//
//  ViewController.h
//  DeviceTracker
//
//  Created by Marek Mościchowski on 19/05/15.
//  Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignIn;
@class AFHTTPSessionManager;

@interface ViewController : UIViewController <GPPSignInDelegate, NSXMLParserDelegate>


@property(nonatomic, strong) GPPSignIn *googleSignIn;
@property(nonatomic, strong) IBOutlet UITextField *textField;

@property(nonatomic, strong) NSXMLParser *parser;

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property(nonatomic, strong) NSMutableDictionary *deviceNumbers;
@property(nonatomic, strong) NSMutableDictionary *deviceNames;

@property(nonatomic, strong) NSMutableArray *devices;

@property(nonatomic, copy) NSString *value;

- (IBAction)signIn;
- (IBAction)super;

@end

