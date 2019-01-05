//
//  GridGameView.h
//  Balls
//
//  Created by Максим Сорокин on 05.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridGameView : NSObject

- (instancetype)initWithFrame:(CGRect)frame;

- (NSArray *)searchOrientingMovementsAroundSourcePosition:(NSUInteger)position;

- (CGRect)frameBoxViewForBallAtPositionOnWidth:(NSUInteger)positionOnWidth positionOnHeight: (NSUInteger)positionOnHeight;

- (NSUInteger)ordinalNumberForBallAtPositionOnWidth:(NSUInteger)positionOnWidth positionOnHeight: (NSUInteger)positionOnHeight;

- (NSUInteger)countPositionOnWidth;

- (NSUInteger)countPositionOnHeight;

- (NSUInteger)allPositions;

@end


