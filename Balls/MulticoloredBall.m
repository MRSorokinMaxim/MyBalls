//
//  MulticoloredBalls.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "MulticoloredBall.h"

@implementation MulticoloredBall


- (instancetype)init
{
    self = [super init];
    if (self) {
        _image = nil;
        _small = NO;
    }
    return self;
}
@end
