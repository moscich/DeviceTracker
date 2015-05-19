//
//  ViewController.m
//  DeviceTracker
//
//  Created by Marek Mościchowski on 19/05/15.
//  Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <AFNetworking/AFHTTPSessionManager.h>

static NSString *const kClientId = @"302427111235-5npfcs0jqaik1l1k9tl9kh6o0rghvgp1.apps.googleusercontent.com";

@interface ViewController ()

@end

@implementation ViewController

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
  NSLog(@"auth = %@", auth);
  self.sessionManager = [AFHTTPSessionManager new];
  self.sessionManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
  self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/atom+xml"];
  NSString *string = auth.accessToken;
  [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", string] forHTTPHeaderField:@"Authorization"];
  [self.sessionManager GET:@"https://spreadsheets.google.com/feeds/spreadsheets/private/full" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      NSXMLParser *parser = responseObject;
      parser.delegate = self;
      [parser parse];
      self.parser = parser;
      NSLog(@"responseObject = %@", responseObject);
  }                failure:^(NSURLSessionDataTask *task, NSError *error2) {
      NSLog(@"task = %@", error2);
  }];
}

- (void)signIn {
  self.googleSignIn = [GPPSignIn sharedInstance];
  self.googleSignIn.shouldFetchGooglePlusUser = YES;
  self.googleSignIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
  self.googleSignIn.shouldFetchGoogleUserID = YES;  // Uncomment to get the user's email

  // You previously set kClientId in the "Initialize the Google+ client" step
  self.googleSignIn.clientID = kClientId;

  // Uncomment one of these two statements for the scope you chose in the previous step
//  signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
  self.googleSignIn.scopes = @[@"profile", @"https://spreadsheets.google.com/feeds"];            // "profile" scope

  // Optional: declare signIn.actions, see "app activities"
  self.googleSignIn.delegate = self;

  [[GPPSignIn sharedInstance] authenticate];
}

- (void)logout {
  [self.googleSignIn disconnect];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
  NSLog(@"parser  TEST = %@", parser);
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
  NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
  NSLog(@"didStartElement --> %@", elementName);
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  NSLog(@"foundCharacters --> %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  NSLog(@"didEndElement   --> %@", elementName);
}

@end
