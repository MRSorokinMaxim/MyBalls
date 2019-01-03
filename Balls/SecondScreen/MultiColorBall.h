//
//  MultiColorBall.h
//  Balls
//
//  Created by Максим Сорокин on 02.09.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSUInteger kWidthRectBall = 100;
static const NSUInteger kHeightRectBall = 100;

@interface MultiColorBall : UIImageView <NSCopying>

@property (nonatomic) CGPoint returnCentre;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) MultiColorBall *backgroundBall;

- (void)addBallImageWithPath:(NSString *)path;

+ (MultiColorBall *)createBallFrom:(MultiColorBall *)ball;

- (void)deleteBall;

- (void)animatingRecoveryStandardBallSizeWithCompletionBlock:(void(^)(BOOL finished))complection;

- (void)animatingCurrentSizeBall;

@end
