//
//  PresentViewController.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "PresentViewController.h"
#import "GameView.h"
#import "BoxBallView.h"
#import "MulticoloredBallsViewModel.h"
#import "Header.h"
#import "MultiColorBall.h"

@interface PresentViewController () <GameViewDrawingDelegate>

@property (strong, nonatomic) MultiColorBall *currentBall;
@property (strong, nonatomic) GameView *gameView;
@property (strong, nonatomic) MulticoloredBallsViewModel *viewModel;
@property (nonatomic) BOOL anim;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameView = [[GameView alloc] initWithFrame:self.view.bounds];
    self.gameView.delegate = self;
    [self.view addSubview:self.gameView];
    self.viewModel = [[MulticoloredBallsViewModel alloc] init];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.gameView addGestureRecognizer:tapGestureRecognizer];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.gameView addGestureRecognizer:panGestureRecognizer];

    self.anim = NO;
}


#pragma mark - UIPanGestureRecognizer


- (void)addBallFromBox:(BoxBallView *)box {
    self.currentBall = [MultiColorBall createBallFrom:box.mainBall];
    [self.gameView addSubview:self.currentBall];
}

- (void)replaceBallAtGameViewFromBox:(BoxBallView *)box {
    [self addBallFromBox:box];
    [self.viewModel addFreePosition:@(box.tag)];
    [box deleteBall];
    NSLog(@"add free %lu",(unsigned long)box.tag);
}

- (void)replaceBallAtBox:(BoxBallView *)box {
    [box createBallWithPathImage:self.currentBall.imagePath];
    [self.viewModel removeFreePosition:@(box.tag)];
    [self.currentBall deleteBall];
    NSLog(@"remove %lu",(unsigned long)box.tag);
}

- (void)animationReturnBall {
    __weak PresentViewController *weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.currentBall.center = weakSelf.currentBall.returnCentre;
    } completion:^(BOOL finished) {
        for (UIView *sourceView in weakSelf.gameView.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                BoxBallView *ball = (BoxBallView *)sourceView;
                if (CGRectContainsPoint(ball.frame, weakSelf.currentBall.returnCentre)) {
                    [weakSelf replaceBallAtBox:ball];
                    weakSelf.currentBall = ball.mainBall;
                    [weakSelf.currentBall animatingCurrentSizeBall];
                    weakSelf.anim = NO;
                    break;
                }
            }
        }
    }];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.gameView];
    if (gesture.state == UIGestureRecognizerStateBegan && !self.anim) {
        [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
        for (UIView *sourceView in self.gameView.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {                
                BoxBallView *ball = (BoxBallView *)sourceView;
                if (CGRectContainsPoint(ball.frame, touchPoint) && ball.subviews.count) {
                    NSLog(@"began");
                    self.anim = YES;
                    [self replaceBallAtGameViewFromBox:ball];
                }
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && self.anim) {
        for (UIView *sourceView in self.gameView.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                BoxBallView *ball = (BoxBallView *)sourceView;
                [self.currentBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
                self.currentBall.center = touchPoint;
                if (CGRectContainsPoint(ball.frame, touchPoint) && ball.subviews.count) {
                    ball.backgroundColor = [UIColor redColor];
                }
                else if (CGRectContainsPoint(ball.frame, touchPoint) && !ball.subviews.count) {
                    ball.backgroundColor = [UIColor yellowColor];
                }
                else {
                    ball.backgroundColor = [UIColor clearColor];
                }
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded && self.anim) {
        for (UIView *sourceView in self.gameView.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                BoxBallView *ball = (BoxBallView *)sourceView;
                ball.backgroundColor = [UIColor clearColor];
                if (CGRectContainsPoint(ball.frame, self.currentBall.center) && !ball.subviews.count) {
                    [self replaceBallAtBox:ball];
                    [self addNewBallsOnScreen];
                    self.anim = NO;
                    break;
                }
                else if (CGRectContainsPoint(ball.frame, self.currentBall.center) && ball.subviews.count) {
                    [self animationReturnBall];
                    break;
                }
                else if ([self.gameView.subviews[self.gameView.subviews.count - 2] isEqual:sourceView]) {
                    [self animationReturnBall];
                    break;
                }
            }
        }
    }
}


#pragma mark - UITapGestureRecognizer


- (void)tap:(UITapGestureRecognizer *)gesture {
    if (!self.anim) {
        CGPoint pointTouch = [gesture locationInView:self.gameView];
        [self animatingBallAtPoint:pointTouch];
    }
}

- (void)animatingBallAtPoint:(CGPoint)pointTouch {
    MultiColorBall *ball = [self сhoiseRect:pointTouch];
    if (self.currentBall) {
        __weak PresentViewController *weakSelf = self;
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
    for (BoxBallView *box in self.gameView.subviews) {
        if (CGRectContainsPoint(box.frame, pointTouch)) {
            returnBall = box.mainBall;
        }
    }
    return returnBall;
}


#pragma mark - GameViewDrawingDelegate


- (void)start {
    [self.viewModel fillFreePositionsWithNumbers:self.gameView.subviews.count];
    [self addNewBallsOnScreen];
}


#pragma mark - Private


- (void)addNewBallsOnScreen {
    NSSet *freePositions = [self.viewModel searchFreePositionAmongNumbers:self.gameView.subviews.count];
    for (NSNumber *freePosition in freePositions) {
        NSString *pathImageBall = [self.viewModel randomImageNameBall];
        [(BoxBallView *)self.gameView.subviews[freePosition.integerValue] createBallWithPathImage:pathImageBall];
    }
}
@end
