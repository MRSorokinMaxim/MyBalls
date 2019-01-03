//
//  MulticoloredBallsViewModel.h
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MulticoloredBallsViewModel : NSObject

- (NSString *)randomImageNameBall;

- (NSSet *)searchFreePositionAmongNumbers:(NSUInteger)allNumbers;

- (void)fillFreePositionsWithNumbers:(NSUInteger)allNumbers;

- (void)addFreePosition:(NSNumber *)number;

- (void)removeFreePosition:(NSNumber *)number;

@end
