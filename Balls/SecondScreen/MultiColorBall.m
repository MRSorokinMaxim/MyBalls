//
//  MultiColorBall.m
//  Balls
//
//  Created by Максим Сорокин on 02.09.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "MultiColorBall.h"
#import "Header.h"

@interface MultiColorBall ()

@property (nonatomic) CGSize sizeAnimationBall;

@end
@implementation MultiColorBall

- (id)copyWithZone:(NSZone *)zone {
    MultiColorBall *ball = [[[self class] allocWithZone:zone] init];
    if (ball) {
        ball.imagePath = [_imagePath copy];
        ball.returnCentre = _returnCentre;
        ball.image = [UIImage imageNamed:ball.imagePath];
        ball.backgroundBall = _backgroundBall;
    }
    return ball;
}

- (void)addBallImageWithPath:(NSString *)path {
    self.backgroundBall = [[MultiColorBall alloc] initWithFrame:self.bounds];
    self.backgroundBall.image = [UIImage imageNamed:path];
    self.backgroundBall.alpha = 0.0f;
    self.image = [UIImage imageNamed:path];
    self.imagePath = path;
}

+ (MultiColorBall *)createBallFrom:(MultiColorBall *)ball {
    MultiColorBall *newBall = [ball copy];
    newBall.center = ball.center;
    return newBall;
}

- (void)deleteBall {
    [self.backgroundBall removeFromSuperview];
    [self removeFromSuperview];
    self.imagePath = nil;
}

- (void)animatingRecoveryStandardBallSizeWithCompletionBlock:(void(^)(BOOL finished))complection {
    CGRect standardBound = CGRectMake(CGRectGetMinX(self.bounds),
                                      CGRectGetMinY(self.bounds),
                                      kWidthRectBall,
                                      kHeightRectBall);
    [self.layer removeAllAnimations];
    __weak MultiColorBall *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        weakSelf.bounds = standardBound;
    } completion:^(BOOL finished) {
        complection ? complection(finished) : nil;
    }];
}

- (void)animatingCurrentSizeBall {
    
    CGRect oldFrame = CGRectMake(CGRectGetMaxX(self.frame),
                                 CGRectGetMaxY(self.frame),
                                 kWidthRectBall,
                                 kHeightRectBall);
    CGRect newFrame = CGRectMake(CGRectGetMaxX(self.frame),
                                 CGRectGetMaxY(self.frame),
                                 kWidthRectBall / 1.5f,
                                 kHeightRectBall / 1.5f);
    
    CGPoint centre = self.center;
    
    self.sizeAnimationBall = CGSizeMake(CGRectGetWidth(self.bounds) + 10.f,
                                        CGRectGetHeight(self.bounds) + 10.f);
    
    CGRect variableRect = CGRectMake(CGRectGetMaxX(self.frame),
                                     CGRectGetMaxY(self.frame),
                                     MIN(self.sizeAnimationBall.width, kWidthRectBall + 50.f),
                                     MIN(self.sizeAnimationBall.height, kHeightRectBall + 50.f));
    
    
    [self.layer removeAllAnimations];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.alpha = 0.8;
        self.frame = variableRect;
        self.center = centre;
        
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1;
                self.frame = newFrame;
                self.center = centre;
            } completion:^(BOOL finished) {
                if(finished){
                    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options: UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionBeginFromCurrentState  animations:^{
                        
                        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                            self.frame = oldFrame;
                            self.center = centre;
                        }];
                        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                            self.frame = newFrame;
                            self.center = centre;
                        }];
                        
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
                            self.frame = oldFrame;
                            self.center = centre;
                        } completion:^(BOOL finished) {
                        }];
                    }];
                }
            }];
        }
    }];
}


@end
