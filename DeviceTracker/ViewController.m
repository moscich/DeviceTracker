//
//  ViewController.m
//  DeviceTracker
//
//  Created by Marek Mościchowski on 19/05/15.
//  Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import "XMLDictionary.h"
#import "DeviceDTO.h"
#import "AFHTTPRequestOperation.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

static NSString *const kClientId = @"302427111235-5npfcs0jqaik1l1k9tl9kh6o0rghvgp1.apps.googleusercontent.com";

@interface ViewController ()

@end

@implementation ViewController

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
  NSLog(@"auth = %@", auth);

  dispatch_group_t group = dispatch_group_create();

//  dispatch_group_enter(group);
  self.sessionManager = [AFHTTPSessionManager new];
  self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
  self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/atom+xml"];
  self.value = [NSString stringWithFormat:@"Bearer %@", auth.accessToken];
  [self.sessionManager.requestSerializer setValue:self.value forHTTPHeaderField:@"Authorization"];
  [self.sessionManager GET:@"https://spreadsheets.google.com/feeds/cells/1Y19H0qUeI1FEetqL6165LHVn9qzxIz6oMjw4X_heXO8/od6/private/full?min-row=2&min-col=1&max-col=2" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
              XMLDictionaryParser *parser1 = [XMLDictionaryParser new];
              NSDictionary *dictionary = [parser1 dictionaryWithData:responseObject];
              NSArray *entries = dictionary[@"entry"];
              self.deviceNumbers = [NSMutableDictionary new];
              NSLog(@"dictionary = %@", dictionary);
              self.devices = [NSMutableArray new];

              for (int i = 0; i < entries.count; i++) {
                NSDictionary *entry = entries[(NSUInteger) i];
                if ([entry[@"gs:cell"][@"_col"] intValue] == 1) {
                  DeviceDTO *device = [DeviceDTO new];
                  device.number = [entry[@"gs:cell"][@"_inputValue"] intValue];
                  device.row = [entry[@"gs:cell"][@"_row"] intValue];
                  [self.devices addObject:device];
                }
              }
              for (int i = 0; i < entries.count; i++) {
                NSDictionary *entry = entries[(NSUInteger) i];
                if ([entry[@"gs:cell"][@"_col"] intValue] == 2) {
                  DeviceDTO *device = [self deviceForRow:[entry[@"gs:cell"][@"_row"] intValue]];
                  device.name = entry[@"gs:cell"][@"_inputValue"];
                }

              }

          }
                   failure:
                           ^(NSURLSessionDataTask *task, NSError *error2) {
                               NSLog(@"task = %@", error2);
                           }];

//  dispatch_group_enter(group);
//
//  [self.sessionManager GET:@"https://spreadsheets.google.com/feeds/cells/1Y19H0qUeI1FEetqL6165LHVn9qzxIz6oMjw4X_heXO8/od6/private/full?min-row=2&min-col=2&max-col=1" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//      XMLDictionaryParser *parser1 = [XMLDictionaryParser new];
//      NSDictionary *dictionary = [parser1 dictionaryWithData:responseObject];
//      NSMutableArray *titlesArray = [NSMutableArray new];
//      NSArray *entries = dictionary[@"entry"];
//      self.deviceNames = [NSMutableDictionary new];
//
//      for (int i = 0; i < entries.count; i++) {
//        NSDictionary *entry = entries[(NSUInteger) i];
//        NSDictionary *entryCell = entry[@"gs:cell"];
//        [titlesArray addObject:entryCell[@"_inputValue"]];
//        self.deviceNames[entryCell[@"_row"]] = entryCell[@"_inputValue"];
//      }
//
//      NSLog(@"titlesArray = %@", self.deviceNumbers);
//      dispatch_group_leave(group);
//
//  }                failure:^(NSURLSessionDataTask *task, NSError *error2) {
//      NSLog(@"task = %@", error2);
//  }];
//
//  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//      NSMutableArray *deviceArray = [NSMutableArray new];
//      for(NSString *key in self.deviceNumbers.allKeys){
//        DeviceDTO *device = [DeviceDTO new];
//        device.number = [self.deviceNumbers[key] intValue];
//        device.name = self.deviceNames[key];
//        device.lenderCellAddress = CGPointMake([key intValue], 3);
//        [deviceArray addObject:device];
//      }
//      NSLog(@"deviceArray = %@", deviceArray);
//  });
}

- (DeviceDTO *)deviceForRow:(int)row {
  for (DeviceDTO *device in self.devices) {
    if (device.row == row)
      return device;
  }
  return nil;
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

- (void)super {



  NSString *entry = @"<entry xmlns=\"http://www.w3.org/2005/Atom\"\n"
          "    xmlns:gs=\"http://schemas.google.com/spreadsheets/2006\">\n"
          "  <id>https://spreadsheets.google.com/feeds/cells/1Y19H0qUeI1FEetqL6165LHVn9qzxIz6oMjw4X_heXO8/od6/private/full/R3C2/5roepi</id>\n"
          "  <link rel=\"edit\" type=\"application/atom+xml\"\n"
          "    href=\"https://spreadsheets.google.com/feeds/cells/1Y19H0qUeI1FEetqL6165LHVn9qzxIz6oMjw4X_heXO8/od6/private/full/R3C2/5roepi\"/>\n"
          "  <gs:cell row=\"3\" col=\"2\" inputValue=\"TEST IOS\"/>\n"
          "</entry>";



  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://spreadsheets.google.com/feeds/cells/1Y19H0qUeI1FEetqL6165LHVn9qzxIz6oMjw4X_heXO8/od6/private/full/R3C2/5roepi"]
                                                         cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];

  [request setHTTPMethod:@"PUT"];
  [request setValue:self.value forHTTPHeaderField:@"Authorization"];
  [request setValue: @"application/atom+xml" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody: [entry dataUsingEncoding:NSUTF8StringEncoding]];

  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFHTTPResponseSerializer serializer];
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      NSLog(@"JSON responseObject: %@ ",string);

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", [error localizedDescription]);

  }];
  [op start];

}

- (void)logout {
  [self.googleSignIn disconnect];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  NSLog(@"parser  TEST = %@", parser);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
  NSLog(@"parserDidStartDocument");
}

- (void) parser:(NSXMLParser *)parser
didStartElement:
        (NSString *)elementName
   namespaceURI:
           (NSString *)namespaceURI
  qualifiedName:
          (NSString *)qName
     attributes:
             (NSDictionary *)attributeDict {
//  NSLog(@"attributeDict = %@", attributeDict);
//  NSLog(@"qName = %@", qName);
//  NSLog(@"namespaceURI = %@", namespaceURI);
//  NSLog(@"didStartElement --> %@", elementName);
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:
        (NSString *)string {
  NSLog(@"foundCharacters --> %@", string);
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:
         (NSString *)elementName
  namespaceURI:
          (NSString *)namespaceURI
 qualifiedName:
         (NSString *)qName {
  NSLog(@"didEndElement   --> %@", elementName);
}

@end
