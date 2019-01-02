//
//  MulticoloredBallsViewModel.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "MulticoloredBallsViewModel.h"
#import <UIKit/UIKit.h>
#import "BoxBallView.h"
#import "GameView.h"

@implementation MulticoloredBallsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.freePositionBalls = [[NSMutableSet alloc] init];
    }
    return self;
}

+ (NSString *)randomImageNameBall {
    switch (arc4random()%5) {
        case 0:
            return @"BallBlue.png";
        case 1:
            return @"BallPurple.png";
        case 2:
            return @"BallRed.png";
        case 3:
            return @"BallGreen.png";
        case 4:
            return @"BallYellow.png";
    }
    return nil;
}

@end
