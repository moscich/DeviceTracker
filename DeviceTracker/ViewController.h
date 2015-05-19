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

@property(nonatomic, strong) NSXMLParser *parser;

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

- (IBAction)signIn;
@end

