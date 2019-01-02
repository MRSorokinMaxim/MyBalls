//
//  BoxBallView.h
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MulticoloredBall;

@interface BoxBallView : UIView <NSCopying>

@property (strong, nonatomic) UIImageView *ball;
@property (strong, nonatomic) UIImageView *backgroundBall;
@property (nonatomic) NSUInteger position;
@property (nonatomic) CGPoint returnCentre;
@property (strong, nonatomic) NSString *pathImage;

- (void)animatingRecoveryStandardBallSizeWithCompletionBlock:(void(^)(BOOL finished))complection;

- (void)createBallWithPathImage:(NSString *)pathBallImage;

- (void)deleteBall;

+ (BoxBallView *)createBoxFrom:(BoxBallView *)box;


@end
