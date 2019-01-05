//
//  ShortestPathAlgorithm.m
//  Balls
//
//  Created by Максим Сорокин on 04.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import "ShortestPathAlgorithm.h"

@interface ShortestPathAlgorithm ()

@property (nonatomic, strong) NSMutableArray *gridBalls;

@property (nonatomic) NSInteger countBallOnWidth;
@property (nonatomic) NSInteger countBallOnHeight;

@property (nonatomic) NSInteger startPosition;
@property (nonatomic) NSInteger endPosition;

@end

@implementation ShortestPathAlgorithm

static const NSInteger kWall = -1;
static const NSInteger kBlank = -2;

- (NSArray *)searchAllPossibleNumbersBallsAroundSourceBox:(NSUInteger)position {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSInteger nextPositionBox = [self notLastBallAtHeightForPosition:position] ? position + 1 : -1;
    NSInteger prevPositionBox = [self notFirstBallAtHeightForPosition:position] ? position - 1 : -1;
    NSInteger rightPositionBox = position + [self countBallOnHeight];
    NSInteger leftPositionBox = position - [self countBallOnHeight];
    NSArray *allPosition = @[@(nextPositionBox),@(prevPositionBox),@(rightPositionBox),@(leftPositionBox)];
    for (NSNumber *position in allPosition) {
        if (position.integerValue >= 0 && position.integerValue < self.countBallOnWidth * self.countBallOnHeight) {
            [result addObject:position];
        }
    }
    return result;
}

- (BOOL)notFirstBallAtHeightForPosition:(NSUInteger)currentPositionBox {
    return currentPositionBox % [self countBallOnHeight] != 0;
}

- (BOOL)notLastBallAtHeightForPosition:(NSUInteger)currentPositionBox {
    return currentPositionBox % [self countBallOnHeight] != [self countBallOnHeight] - 1;
}

- (NSMutableArray *)start {
    NSMutableArray *grid = [[NSMutableArray alloc] init];
    for (NSUInteger position = 0; position < self.gridBalls.count; position++) {
        grid[position] = @([self.gridBalls[position] isEqual:@1] ? kWall : kBlank);
    }
    
    grid[self.startPosition] = @(0);// стартовая ячейка помечена 0
    
    NSInteger step = 0;
    BOOL stop;
    
    do {
        stop = true;               // предполагаем, что все свободные клетки уже помечены
        for (NSUInteger position = 0; position < self.countBallOnWidth * self.countBallOnHeight; position++){
            if ([grid[position] isEqual:@(step)]) {                         // ячейка (x, y) помечена числом step
                NSArray *orientationMovePosition = [self searchAllPossibleNumbersBallsAroundSourceBox:position];
                for (NSNumber *orientationPosition in orientationMovePosition) {
                    if ([grid[orientationPosition.integerValue] isEqual:@(kBlank)]) {
                        stop = false;              // найдены непомеченные клетки
                        grid[orientationPosition.integerValue] = @(step + 1);      // распространяем волну
                    }
                }
            }
        }
        step++;
    } while (!stop && [grid[self.endPosition] isEqual:@(kBlank)]);
    
    if ([grid[self.endPosition] isEqual:@(kBlank)]) {
        NSLog(@"путь не найден");
        return [@[] mutableCopy];
    }
    
    // восстановление пути
    
    NSInteger len = ((NSNumber *)grid[self.endPosition]).integerValue;            // длина кратчайшего пути из self.startPosition в self.endPosition
    NSMutableArray *path = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index <= len; index++) {
        [path addObject:@(0)];
    }
    NSInteger position = self.endPosition;
    step = len;
    while (step > 0) {
        path[step] = @(position);  // записываем ячейку (x, y) в путь
        step--;
        NSArray *orientationMovePosition = [self searchAllPossibleNumbersBallsAroundSourceBox:position];
        for (NSNumber *orientationPosition in orientationMovePosition) {
            if ([grid[orientationPosition.integerValue] isEqual:@(step)]) {
                position = orientationPosition.integerValue; // переходим в ячейку, которая на 1 ближе к старту
                break;
            }
        }
    }
    path[0] = @(self.startPosition);                   // теперь px[0..len]  - координаты ячеек пути

    return path;
}

@end
