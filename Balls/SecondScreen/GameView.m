//
//  GameView.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "GameView.h"

#import "BoxBallView.h"
#import "MultiColorBall.h"

@interface GameView ()

@property (strong, nonatomic) MultiColorBall *currentBall;

@property (nonatomic) BOOL movingBall;

@end

@implementation GameView


#pragma mark - Initialization


- (void)setup {
    self.backgroundColor = nil;
    self.opaque= NO;
    self.contentMode = UIViewContentModeRedraw;
    [self setNeedsDisplay];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureRecognizer];
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
            boxView.tag = countBallOnWidth * [self countBallOnHeight] + countBallOnHeight;
            [self addSubview:boxView];
        }
    }
}

- (void)addBallOnPosition:(NSUInteger)freePosition withPathImage:(NSString *)pathImage {
    [(BoxBallView *)self.subviews[freePosition] createBallWithPathImage:pathImage];
}

#pragma mark - UIPanGestureRecognizer


- (void)addBallFromBox:(BoxBallView *)box {
    self.currentBall = [MultiColorBall createBallFrom:box.mainBall];
    [self addSubview:self.currentBall];
}

- (void)replaceBallAtGameViewFromBox:(BoxBallView *)box {
    [self addBallFromBox:box];
    [self.delegate freePosition:box.tag];
    [box deleteBall];
    NSLog(@"add free %lu",(unsigned long)box.tag);
}

- (void)replaceBallAtBox:(BoxBallView *)box {
    [box createBallWithPathImage:self.currentBall.imagePath];
    [self.delegate takePosition:box.tag];
    [self.currentBall deleteBall];
    NSLog(@"remove %lu",(unsigned long)box.tag);
}

- (void)animationReturnBall {
    __weak GameView *weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.currentBall.center = weakSelf.currentBall.returnCentre;
    } completion:^(BOOL finished) {
        UIView *sourceView = [weakSelf hitTest:weakSelf.currentBall.returnCentre withEvent:nil];
        if ([sourceView isKindOfClass:[BoxBallView class]]) {
            BoxBallView *box = (BoxBallView *)sourceView;
            [weakSelf replaceBallAtBox:box];
            weakSelf.currentBall = box.mainBall;
            [box.mainBall animatingCurrentSizeBall];
            weakSelf.movingBall = NO;
        }
    }];
}

- (void)panHandler:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan && !self.movingBall) {
        [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
        UIView *sourceView = [self hitTest:touchPoint withEvent:nil];
        if ([sourceView isKindOfClass:[BoxBallView class]]) {
            BoxBallView *box = (BoxBallView *)sourceView;
            if (CGRectContainsPoint(box.frame, touchPoint) && box.subviews.count) {
                NSLog(@"began");
                self.movingBall = YES;
                [self replaceBallAtGameViewFromBox:box];
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && self.movingBall) {
        for (UIView *sourceView in self.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
                BoxBallView *box = (BoxBallView *)sourceView;
                [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
                self.currentBall.center = touchPoint;
                [box determineBackgroundColorDependingOnTouchPoint:touchPoint];
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded && self.movingBall) {
        UIView *sourceView = [self hitTest:touchPoint withEvent:nil];
        if ([sourceView isKindOfClass:[BoxBallView class]]) {
            BoxBallView *box = (BoxBallView *)sourceView;
            box.backgroundColor = [UIColor clearColor];
            if (CGRectContainsPoint(box.frame, self.currentBall.center) && !box.subviews.count) {
                [self replaceBallAtBox:box];
                [self.delegate addNewBallsOnGameView];
                self.movingBall = NO;
            }
            else if (CGRectContainsPoint(box.frame, self.currentBall.center) && box.subviews.count) {
                [self animationReturnBall];
            }
        }
        else {
            [self animationReturnBall];
        }
    }
}


#pragma mark - UITapGestureRecognizer


- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    if (!self.movingBall) {
        CGPoint pointTouch = [gesture locationInView:self];
        [self animatingBallAtPoint:pointTouch];
    }
}

- (void)animatingBallAtPoint:(CGPoint)pointTouch {
    MultiColorBall *ball = [self сhoiseRect:pointTouch];
    if (self.currentBall) {
        __weak GameView *weakSelf = self;
        [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:^(BOOL finished) {
            weakSelf.currentBall = ball;
            [weakSelf.currentBall animatingCurrentSizeBall];
        }];
    }
    else {
        self.currentBall = ball;
        [self.currentBall animatingCurrentSizeBall];
    }
}

- (MultiColorBall *)сhoiseRect:(CGPoint)pointTouch {
    MultiColorBall *returnBall = nil;
    for (BoxBallView *box in self.subviews) {
        if (CGRectContainsPoint(box.frame, pointTouch)) {
            returnBall = box.mainBall;
        }
    }
    return returnBall;
}


@end
