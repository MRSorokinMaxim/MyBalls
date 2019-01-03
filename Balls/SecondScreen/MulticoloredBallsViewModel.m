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

@interface MulticoloredBallsViewModel ()

@property (strong, nonatomic) NSMutableSet *freePositionBalls;

@end

@implementation MulticoloredBallsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.freePositionBalls = [[NSMutableSet alloc] init];
    }
    return self;
}

- (NSString *)randomImageNameBall {
    switch (arc4random() % 5) {
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


- (void)addFreePosition:(NSNumber *)number {
    [self.freePositionBalls addObject:number];
}

- (void)removeFreePosition:(NSNumber *)number {
    [self.freePositionBalls removeObject:number];
}

- (NSSet *)searchFreePositionAmongNumbers:(NSUInteger)allNumbers {
    NSMutableSet *freePosition = [[NSMutableSet alloc] init];
    NSUInteger countBallForDraw = 3;//arc4random() % 4 + 1;
    while (countBallForDraw) {
        NSNumber *randomPositionForDrawBall = @(arc4random() % allNumbers);
        if ([self.freePositionBalls containsObject:randomPositionForDrawBall]) {
            [self removeFreePosition:randomPositionForDrawBall];
            [freePosition addObject:randomPositionForDrawBall];
            countBallForDraw--;
        }
        if (!self.freePositionBalls.count) {
            break;
        }
    }
    return freePosition;
}

- (void)fillFreePositionsWithNumbers:(NSUInteger)allNumbers {
    for (NSUInteger position = 0; position < allNumbers; position++) {
        [self addFreePosition:@(position)];
    }
}

@end
