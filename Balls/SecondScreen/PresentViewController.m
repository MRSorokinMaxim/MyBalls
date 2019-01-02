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

@interface PresentViewController () <GameViewDrawingDelegate>

@property (strong, nonatomic) BoxBallView *currentBoxBall;
@property (nonatomic) CGSize sizeAnimationBall;
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
    self.currentBoxBall = [BoxBallView createBoxFrom:box];
    [box addSubview:self.currentBoxBall.backgroundBall];
    [self.gameView addSubview:self.currentBoxBall.mainBall];
}

- (void)replaceBallAtGameViewFromBox:(BoxBallView *)box {
    [self addBallFromBox:box];
    [self.viewModel.freePositionBalls addObject:@(box.position)];
    [box deleteBall];
    NSLog(@"add free %lu",(unsigned long)box.position);
}

- (void)replaceBallAtBox:(BoxBallView *)box {
    [box createBallWithPathImage:self.currentBoxBall.pathImage];
    [self.viewModel.freePositionBalls removeObject:@(box.position)];
    [self.currentBoxBall deleteBall];
    NSLog(@"remove %lu",(unsigned long)box.position);
}

- (void)animationReturnBall {
    __weak PresentViewController *weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.currentBoxBall.mainBall.center = weakSelf.currentBoxBall.returnCentre;
    } completion:^(BOOL finished) {
        for (UIView *sourceView in weakSelf.gameView.subviews) {
            if ([sourceView isKindOfClass:[BoxBallView class]]) {
                BoxBallView *ball = (BoxBallView *)sourceView;
                if (CGRectContainsPoint(ball.frame, weakSelf.currentBoxBall.returnCentre)) {
                    [weakSelf replaceBallAtBox:ball];
                    weakSelf.currentBoxBall = ball;
                    [weakSelf animatingCurrentSizeBall:weakSelf.currentBoxBall];
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
                if (CGRectContainsPoint(ball.frame, touchPoint) && ball.mainBall) {
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
                self.currentBoxBall.mainBall.center = touchPoint;
                if (CGRectContainsPoint(ball.frame, touchPoint) && ball.mainBall) {
                    ball.backgroundColor = [UIColor redColor];
                }
                else if (CGRectContainsPoint(ball.frame, touchPoint) && !ball.mainBall) {
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
                if (CGRectContainsPoint(ball.frame, self.currentBoxBall.mainBall.center) && !ball.mainBall) {
                    [self replaceBallAtBox:ball];
                    [self addNewBallsOnScreen];
                    self.anim = NO;
                    break;
                }
                else if (CGRectContainsPoint(ball.frame, self.currentBoxBall.mainBall.center) && ball.mainBall) {
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
    [self.viewModel.freePositionBalls addObject:@(fromGameRect.position)];
    [self.viewModel.freePositionBalls removeObject:@(toGameRect.position)];
    [toGameRect createBallWithPathImage:self.currentBoxBall.pathImage];
    [fromGameRect deleteBall];

}
- (void)animatingBallAtPoint:(CGPoint)pointTouch {
    BoxBallView *box = [self сhoiseRect:pointTouch];
    if (![self.currentBoxBall isEqual:box]) {
        if (self.currentBoxBall) {
            __weak PresentViewController *weakSelf = self;
            [self.currentBoxBall animatingRecoveryStandardBallSizeWithCompletionBlock:^(BOOL finished) {
                weakSelf.currentBoxBall = box;
                [weakSelf animatingCurrentSizeBall:weakSelf.currentBoxBall];
            }];
        }
        else {
            self.currentBoxBall = box;
            [self animatingCurrentSizeBall:self.currentBoxBall];
        }
    }
    else {
        [self animatingCurrentSizeBall:self.currentBoxBall];
    }
}

- (void)animatingCurrentSizeBall:(BoxBallView *)ball {
    
    CGRect oldFrame = CGRectMake(CGRectGetMaxX(ball.mainBall.frame),
                                 CGRectGetMaxY(ball.mainBall.frame),
                                 kWidthRectBall,
                                 kHeightRectBall);
    CGRect newFrame = CGRectMake(CGRectGetMaxX(ball.mainBall.frame),
                                 CGRectGetMaxY(ball.mainBall.frame),
                                 kWidthRectBall / 1.5f,
                                 kHeightRectBall / 1.5f);
    
    CGPoint centre = ball.mainBall.center;
    
    self.sizeAnimationBall = CGSizeMake(CGRectGetWidth(ball.mainBall.bounds) + 10.f,
                                        CGRectGetHeight(ball.mainBall.bounds) + 10.f);
    
    CGRect variableRect = CGRectMake(CGRectGetMaxX(ball.mainBall.frame),
                                     CGRectGetMaxY(ball.mainBall.frame),
                                     MIN(self.sizeAnimationBall.width, kWidthRectBall + 50.f),
                                     MIN(self.sizeAnimationBall.height, kHeightRectBall + 50.f));
    
    
    [ball.mainBall.layer removeAllAnimations];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        ball.mainBall.alpha = 0.8;
        ball.mainBall.frame = variableRect;
        ball.mainBall.center = centre;
        
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                ball.mainBall.alpha = 1;
                ball.mainBall.frame = newFrame;
                ball.mainBall.center = centre;
            } completion:^(BOOL finished) {
                if(finished){
                    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options: UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionBeginFromCurrentState  animations:^{
                        
                        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                            ball.mainBall.frame = oldFrame;
                            ball.mainBall.center = centre;
                        }];
                        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                            ball.mainBall.frame = newFrame;
                            ball.mainBall.center = centre;
                        }];
                        
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                            ball.mainBall.frame = oldFrame;
                            ball.mainBall.center = centre;
                        } completion:^(BOOL finished) {
                        }];
                    }];
                }
            }];
        }
    }];
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
