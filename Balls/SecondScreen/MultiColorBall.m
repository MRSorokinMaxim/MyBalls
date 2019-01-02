//
//  MultiColorBall.m
//  Balls
//
//  Created by Максим Сорокин on 02.09.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "MultiColorBall.h"

@implementation MultiColorBall

- (instancetype)initWithimagePath:(NSString *)imagePath returnCentre:(CGPoint)returnCentre {
    self = [super init];
    if (self) {
        self.imagePath = imagePath;
        self.returnCentre = returnCentre;
    }
    return self;
}

@end
