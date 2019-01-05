//
//  AppSetting.m
//  Balls
//
//  Created by Максим Сорокин on 05.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

+ (instancetype)instance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [(AppSettings *) [super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSUInteger)sizeSquareBall {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sizeSquareBall"] == nil) {
        return 100;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sizeSquareBall"];
}

@end
