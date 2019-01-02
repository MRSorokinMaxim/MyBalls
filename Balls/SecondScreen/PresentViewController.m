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

@property (strong, nonatomic) MultiColorBall *currentBoxBall;

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
    self.currentBoxBall = [MultiColorBall createBallFrom:box.mainBall];
    [self.gameView addSubview:self.currentBoxBall];
}

- (void)replaceBallAtGameViewFromBox:(BoxBallView *)box {
    [self addBallFromBox:box];
    [self.viewModel.freePositionBalls addObject:@(box.tag)];
    [box deleteBall];
    NSLog(@"add free %lu",(unsigned long)box.tag);
}

- (void)replaceBallAtBox:(BoxBallView *)box {
    [box createBallWithPathImage:self.currentBoxBall.imagePath];
    [self.viewModel.freePositionBalls removeObject:@(box.tag)];
    [self.currentBoxBall deleteBall];
    NSLog(@"remove %lu",(unsigned long)box.tag);
}

- (void)animationReturnBall {
    __weak PresentViewController *weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.currentBoxBall.center = weakSelf.currentBoxBall.returnCentre;
    } completion:^(BOOL finished) {
        for (UIView *sourceView in weakSelf.gameView.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                BoxBallView *ball = (BoxBallView *)sourceView;
                if (CGRectContainsPoint(ball.frame, weakSelf.currentBoxBall.returnCentre)) {
                    [weakSelf replaceBallAtBox:ball];
                    weakSelf.currentBoxBall = ball.mainBall;
                    [weakSelf.currentBoxBall animatingCurrentSizeBall];
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
        [self.currentBoxBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
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
                [self.currentBoxBall animatingRecoveryStandardBallSizeWithCompletionBlock:nil];
                self.currentBoxBall.center = touchPoint;
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
                if (CGRectContainsPoint(ball.frame, self.currentBoxBall.center) && !ball.subviews.count) {
                    [self replaceBallAtBox:ball];
                    [self addNewBallsOnScreen];
                    self.anim = NO;
                    break;
                }
                else if (CGRectContainsPoint(ball.frame, self.currentBoxBall.center) && ball.subviews.count) {
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


- (BoxBallView *)сhoiseRect:(CGPoint)pointTouch {
    BoxBallView *returnBall = nil;
    for (BoxBallView *ball in self.gameView.subviews) {
        if (CGRectContainsPoint(ball.frame, pointTouch)) {
            returnBall = ball;
        }
    }
    return returnBall;
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (!self.anim) {
        CGPoint pointTouch = [gesture locationInView:self.gameView];
        [self animatingBallAtPoint:pointTouch];
    }
}

- (void)replaceBallFromGameRect:(BoxBallView *)fromGameRect toGameRect:(BoxBallView *)toGameRect {
    NSLog(@"%@",self.viewModel.freePositionBalls);
    [self.viewModel.freePositionBalls addObject:@(fromGameRect.tag)];
    [self.viewModel.freePositionBalls removeObject:@(toGameRect.tag)];
    [toGameRect createBallWithPathImage:self.currentBoxBall.imagePath];
    [fromGameRect deleteBall];

}
- (void)animatingBallAtPoint:(CGPoint)pointTouch {
    BoxBallView *box = [self сhoiseRect:pointTouch];
    if (![self.currentBoxBall isEqual:box]) {
        if (self.currentBoxBall) {
            __weak PresentViewController *weakSelf = self;
            [self.currentBoxBall animatingRecoveryStandardBallSizeWithCompletionBlock:^(BOOL finished) {
                weakSelf.currentBoxBall = box.mainBall;
                [weakSelf.currentBoxBall animatingCurrentSizeBall];
            }];
        }
        else {
            self.currentBoxBall = box.mainBall;
            [self.currentBoxBall animatingCurrentSizeBall];
        }
    }
    else {
        [self.currentBoxBall animatingCurrentSizeBall];
    }
}



#pragma mark - GameViewDrawingDelegate


- (void)start {
    for (NSUInteger position = 0; position < self.gameView.subviews.count; position++) {
        [self.viewModel.freePositionBalls addObject:@(position)];
    }
    [self addNewBallsOnScreen];
}


#pragma mark - Private


- (void)addNewBallsOnScreen {
    NSUInteger countBallForDraw = 3;//arc4random() % 4 + 1;
    while (countBallForDraw) {
        NSNumber *randomPositionForDrawBall = @(arc4random() % self.gameView.subviews.count);
        if ([self.viewModel.freePositionBalls containsObject:randomPositionForDrawBall]) {
            [self.viewModel.freePositionBalls removeObject:randomPositionForDrawBall];
            NSString *pathImageBall = [MulticoloredBallsViewModel randomImageNameBall];
            [(BoxBallView *)self.gameView.subviews[randomPositionForDrawBall.integerValue] createBallWithPathImage:pathImageBall];
            countBallForDraw--;
        }
        if (!self.viewModel.freePositionBalls.count) {
            break;
        }
    }
    
}
@end
