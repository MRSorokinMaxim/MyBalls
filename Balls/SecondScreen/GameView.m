//
//  GameView.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "GameView.h"
#import "BoxBallView.h"
#import "MulticoloredBallsViewModel.h"
#import "Header.h"

@implementation GameView


#pragma mark - Initialization


- (void)setup {
    self.backgroundColor = nil;
    self.opaque= NO;
    self.contentMode = UIViewContentModeRedraw;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}


#pragma mark - Draw


- (void)drawRect:(CGRect)rect {
    [self setupBoxViews];
    [self.delegate start];
}


#pragma mark - Private


- (NSUInteger)countBallOnWidth {
    return (NSUInteger)CGRectGetWidth(self.bounds) / kWidthRectBall;
}

- (NSUInteger)countBallOnHeight {
    return (NSUInteger)CGRectGetHeight(self.bounds) / kHeightRectBall;
}

- (CGFloat)offsetToX {
    return CGRectGetWidth(self.bounds) - kWidthRectBall * [self countBallOnWidth];
}

- (CGFloat)offsetToY {
    return CGRectGetHeight(self.bounds) - kWidthRectBall * [self countBallOnHeight];
}

- (void)setupBoxViews {
    for (NSUInteger countBallOnWidth = 0; countBallOnWidth < [self countBallOnWidth]; countBallOnWidth++){
        for (NSUInteger countBallOnHeight = 0; countBallOnHeight < [self countBallOnHeight]; countBallOnHeight++) {
            CGRect frame = CGRectMake(countBallOnWidth * kWidthRectBall + [self offsetToX] / 2,
                                      countBallOnHeight * kHeightRectBall + [self offsetToY] / 2,
                                      kWidthRectBall,
                                      kHeightRectBall);
            BoxBallView *boxView = [[BoxBallView alloc] initWithFrame:frame];
            boxView.position = countBallOnWidth * [self countBallOnHeight] + countBallOnHeight;
            [self addSubview:boxView];
        }
    }
}


@end
