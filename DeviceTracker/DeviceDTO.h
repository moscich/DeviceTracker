//
// Created by Marek Mościchowski on 20/05/15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface DeviceDTO : NSObject

@property(nonatomic, assign) int number;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) int row;

@end