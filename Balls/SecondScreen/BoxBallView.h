//
//  BoxBallView.h
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiColorBall;

@interface BoxBallView : UIView

@property (strong, nonatomic) MultiColorBall *mainBall;

- (void)createBallWithPathImage:(NSString *)pathBallImage;

- (void)deleteBall;

- (void)determineBackgroundColorDependingOnTouchPoint:(CGPoint)touchPoint;

@end
