//
//  GridGameView.m
//  Balls
//
//  Created by Максим Сорокин on 05.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import "GridGameView.h"

@interface GridGameView ()

@property (nonatomic) CGFloat widthGameView;
@property (nonatomic) CGFloat heightGameView;

@property (nonatomic) CGFloat widthBallView;
@property (nonatomic) CGFloat heightBallView;

@end

@implementation GridGameView


#pragma mark - Initialization


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.widthGameView = CGRectGetWidth(frame);
        self.heightGameView = CGRectGetHeight(frame);
        self.widthBallView = [[AppSettings instance] sizeSquareBall];
        self.heightBallView = [[AppSettings instance] sizeSquareBall];
    }
    return self;
}


#pragma mark - Public


- (NSArray *)searchOrientingMovementsAroundSourcePosition:(NSUInteger)position {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSInteger nextPosition = [self notLastPositionAtHeight:position] ? position + 1 : -1;
    NSInteger prevPosition = [self notFirstPositionAtHeight:position] ? position - 1 : -1;
    NSInteger rightPosition = position + self.countPositionOnHeight;
    NSInteger leftPosition = position - self.countPositionOnHeight;
    NSArray *allPosition = @[@(nextPosition),@(prevPosition),@(rightPosition),@(leftPosition)];
    for (NSNumber *position in allPosition) {
        if (position.integerValue >= 0 && position.integerValue < self.allPositions) {
            [result addObject:position];
        }
    }
    return result;
}

- (CGRect)frameBoxViewForBallAtPositionOnWidth:(NSUInteger)positionOnWidth positionOnHeight: (NSUInteger)positionOnHeight {
    return CGRectMake(positionOnWidth * self.widthBallView + self.offsetToX / 2,
                      positionOnHeight * self.heightBallView + self.offsetToY / 2,
                      self.widthBallView,
                      self.heightBallView);
}

- (NSUInteger)ordinalNumberForBallAtPositionOnWidth:(NSUInteger)positionOnWidth positionOnHeight: (NSUInteger)positionOnHeight {
    return positionOnWidth * self.countPositionOnHeight + positionOnHeight;
}

- (NSUInteger)countPositionOnWidth {
    return (NSUInteger)self.widthGameView / self.widthBallView;
}

- (NSUInteger)countPositionOnHeight {
    return (NSUInteger)self.heightGameView / self.heightBallView;
}

- (NSUInteger)allPositions {
    return self.countPositionOnWidth * self.countPositionOnHeight;
}


#pragma mark - Private


- (BOOL)notFirstPositionAtHeight:(NSUInteger)position {
    return position % self.countPositionOnHeight != 0;
}

- (BOOL)notLastPositionAtHeight:(NSUInteger)position {
    return position % self.countPositionOnHeight != self.countPositionOnHeight - 1;
}

- (CGFloat)offsetToX {
    return self.widthGameView - self.widthBallView * self.countPositionOnWidth;
}

- (CGFloat)offsetToY {
    return self.heightGameView - self.widthBallView * self.countPositionOnHeight;
}

@end
