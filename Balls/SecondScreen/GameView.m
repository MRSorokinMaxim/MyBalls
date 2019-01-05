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


- (void)createBallFromBoxView:(BoxBallView *)boxView {
    self.currentBall = [MultiColorBall createBallFrom:boxView.mainBall];
    [self addSubview:self.currentBall];
}

- (void)replaceBallToGameViewFromBoxView:(BoxBallView *)boxView {
    [self createBallFromBoxView:boxView];
    [self.delegate freePosition:boxView.tag];
    [boxView deleteBall];
    NSLog(@"add free %lu",(unsigned long)boxView.tag);
}

- (void)replaceBallFromGameViewToBoxView:(BoxBallView *)boxView {
    [boxView createBallWithPathImage:self.currentBall.imagePath];
    [self.delegate takePosition:boxView.tag];
    [self.currentBall deleteBall];
    NSLog(@"remove %lu",(unsigned long)boxView.tag);
}

- (void)animationReturnBall {
    __weak GameView *weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.currentBall.center = weakSelf.currentBall.returnCentre;
    } completion:^(BOOL finished) {
        UIView *sourceView = [weakSelf hitTest:weakSelf.currentBall.returnCentre withEvent:nil];
        if ([sourceView isKindOfClass:[BoxBallView class]]) {
            BoxBallView *boxView = (BoxBallView *)sourceView;
            [weakSelf replaceBallFromGameViewToBoxView:boxView];
            [boxView.mainBall animatingCurrentSizeBall];
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
            BoxBallView *boxView = (BoxBallView *)sourceView;
            if (CGRectContainsPoint(boxView.frame, touchPoint) && boxView.subviews.count) {
                NSLog(@"began");
                self.movingBall = YES;
                [self replaceBallToGameViewFromBoxView:boxView];
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && self.movingBall) {
        for (UIView *sourceView in self.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
                BoxBallView *boxView = (BoxBallView *)sourceView;
                [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
                self.currentBall.center = touchPoint;
                [boxView determineBackgroundColorDependingOnTouchPoint:touchPoint];
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded && self.movingBall) {
        UIView *sourceView = [self hitTest:touchPoint withEvent:nil];
        if ([sourceView isKindOfClass:[BoxBallView class]]) {
            BoxBallView *boxView = (BoxBallView *)sourceView;
            boxView.backgroundColor = [UIColor clearColor];
            if (CGRectContainsPoint(boxView.frame, self.currentBall.center) && !boxView.subviews.count) {
                [self replaceBallFromGameViewToBoxView:boxView];
                [self deleteBalls];
                [self.delegate addNewBallsOnGameView];
                self.movingBall = NO;
            }
            else if (CGRectContainsPoint(boxView.frame, self.currentBall.center) && boxView.subviews.count) {
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
    for (BoxBallView *boxView in self.subviews) {
        if (CGRectContainsPoint(boxView.frame, pointTouch)) {
            returnBall = boxView.mainBall;
        }
    }
    return returnBall;
}


#pragma mark - Delete Balls


- (void)deleteBalls {
    NSMutableSet *ballsNumbersToDelete = [[NSMutableSet alloc] init];
    for (NSUInteger positionBox = 0; positionBox < self.subviews.count; positionBox++) {
        if ([self.subviews[positionBox] isKindOfClass:[BoxBallView class]]) {
            BoxBallView *boxView = (BoxBallView *)self.subviews[positionBox];
            if (boxView.subviews.count) {
                NSArray *numbersBallsNearbyToBeRemove = [self searchNumbersBallsAroundSourceBox:positionBox withSamePathImage:boxView.mainBall.imagePath];
                if (numbersBallsNearbyToBeRemove.count > 1) {
                    [ballsNumbersToDelete addObject:@(positionBox)];
                    [ballsNumbersToDelete addObjectsFromArray:numbersBallsNearbyToBeRemove];
                }
            }
        }
    }
    if (ballsNumbersToDelete.count > 2) {
        [self animateRemovingBalls:ballsNumbersToDelete];
    }
}

- (NSArray *)searchNumbersBallsAroundSourceBox:(NSUInteger)positionBox withSamePathImage:(NSString *)pathImage  {
    NSMutableArray *numbersBallsToDelete = [[NSMutableArray alloc] init];
    NSArray *numbersBallsNearby = [self searchAllPossibleNumbersBallsAroundSourceBox:positionBox];
    for (NSNumber *checkNumberBox in numbersBallsNearby) {
        BoxBallView *checkBox = (BoxBallView *)self.subviews[checkNumberBox.integerValue];
        if (checkBox.subviews.count && [checkBox.mainBall.imagePath isEqualToString:pathImage]) {
            [numbersBallsToDelete addObject:checkNumberBox];
        }
    }
    return numbersBallsToDelete;
}

- (NSArray *)searchAllPossibleNumbersBallsAroundSourceBox:(NSUInteger)positionBox {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSInteger nextPositionBox = [self notLastBallAtHeightForPosition:positionBox] ? positionBox + 1 : -1;
    NSInteger prevPositionBox = [self notFirstBallAtHeightForPosition:positionBox] ? positionBox - 1 : -1;
    NSInteger rightPositionBox = positionBox + [self countBallOnHeight];
    NSInteger leftPositionBox = positionBox - [self countBallOnHeight];
    NSArray *allPosition = @[@(nextPositionBox),@(prevPositionBox),@(rightPositionBox),@(leftPositionBox)];
    for (NSNumber *position in allPosition) {
        if (position.integerValue >= 0 && position.integerValue < self.subviews.count) {
            [result addObject:position];
        }
    }
    return result;
}

- (BOOL)notFirstBallAtHeightForPosition:(NSUInteger)currentPositionBox {
    return currentPositionBox % [self countBallOnHeight] != 0;
}

- (BOOL)notLastBallAtHeightForPosition:(NSUInteger)currentPositionBox {
    return currentPositionBox % [self countBallOnHeight] != [self countBallOnHeight] - 1;
}

- (void)animateRemovingBalls:(NSSet *)dropBallsNumbers {
    for (NSNumber *dropBallNumber in dropBallsNumbers) {
        BoxBallView *dropBoxView = self.subviews[dropBallNumber.integerValue];
        [dropBoxView.mainBall animateRemovingWithCompletionBlock:^(BOOL finished) {
            finished ? [self.delegate freePosition:dropBoxView.tag] : nil;
        }];
    }
}

@end
