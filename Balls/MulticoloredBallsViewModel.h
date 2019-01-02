//
//  MulticoloredBallsViewModel.h
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BoxBallView;

@interface MulticoloredBallsViewModel : NSObject

@property (strong, nonatomic) NSMutableSet *freePositionBalls;

+ (NSString *)randomImageNameBall;

@end
