//
//  BoxBallView.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "BoxBallView.h"
#import "MultiColorBall.h"
#import "Header.h"

@implementation BoxBallView

static NSUInteger const kCornerFontStandartHeight = 180;
static NSUInteger const kCornerRadius = 12;


#pragma mark - Draw


- (CGFloat)cornerScaleFactor {
    return CGRectGetHeight(self.bounds) / kCornerFontStandartHeight;
}

- (CGFloat)cornerRadius {
    return kCornerRadius * [self cornerScaleFactor];
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:[self cornerRadius]];
    [roundRect addClip];
    [UIColor.lightGrayColor setStroke];
    [roundRect stroke];
    
}


#pragma mark - Initialization


- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
        _ball = nil;
        _backgroundBall = nil;
        _position = -1;
        _returnCentre = self.center;
        _pathImage = nil;
    }
    return self;
}


#pragma mark - NSCopying


- (id)copyWithZone:(NSZone *)zone {
    BoxBallView *ball = [[[self class] allocWithZone:zone] init];
    if (ball) {
        ball.position = _position;
        ball.returnCentre = _returnCentre;
        ball.pathImage = [_pathImage copy];
        ball.ball = [self createImageViewWithFrame:_ball.frame andImage:ball.pathImage];
        ball.backgroundBall = [self createImageViewWithFrame:_ball.frame andImage:ball.pathImage];
    }
    return ball;
}


#pragma mark - Public


- (UIImageView *)createImageViewWithFrame:(CGRect)frame andImage:(NSString *)pathImage {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:pathImage];
    return imageView;
}

- (void)animatingRecoveryStandardBallSizeWithCompletionBlock:(void(^)(BOOL finished))complection {
    CGRect standardBound = CGRectMake(CGRectGetMinX(self.ball.bounds),
                                      CGRectGetMinY(self.ball.bounds),
                                      kWidthRectBall,
                                      kHeightRectBall);
    [self.ball.layer removeAllAnimations];
    __weak BoxBallView *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        weakSelf.ball.bounds = standardBound;
        weakSelf.backgroundBall.bounds = standardBound;
    } completion:^(BOOL finished) {
        complection ? complection(finished) : nil;
    }];
}

- (void)createBallWithPathImage:(NSString *)pathBallImage {
    UIImageView *ball = [self createImageViewWithFrame:self.bounds andImage:pathBallImage];
    UIImageView *backgroundBall = [self createImageViewWithFrame:self.bounds andImage:pathBallImage];
    self.pathImage = pathBallImage;
    self.ball = ball;
    self.backgroundBall = backgroundBall;
    [self addSubview:ball];
}

- (void)deleteBall {
    [self.backgroundBall removeFromSuperview];
    [self.ball removeFromSuperview];
    self.ball = nil;
    self.pathImage = nil;
}

+ (BoxBallView *)createBoxFrom:(BoxBallView *)box {
    BoxBallView *newBox = [box copy];
    newBox.ball.center = box.center;
    newBox.backgroundBall.alpha = 0.6;
    return newBox;
}

@end
