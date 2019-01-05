//
//  ShortestPathAlgorithm.m
//  Balls
//
//  Created by Максим Сорокин on 04.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import "ShortestPathAlgorithm.h"
#import "GridGameView.h"

@interface ShortestPathAlgorithm ()

@property (nonatomic, strong) NSArray *balls;
@property (strong, nonatomic) GridGameView *gridBalls;
@property (nonatomic) NSInteger startPosition;
@property (nonatomic) NSInteger endPosition;

@end

@implementation ShortestPathAlgorithm

static const NSInteger kWall = -1;
static const NSInteger kBlank = -2;

- (NSArray *)calculatePath {
    if (self.gridBalls.allPositions != self.balls.count) {
        return @[];
    }
    NSArray *preparedGrid = [self prepareGrid];
    NSArray *filledGrid = [self fillGrid:preparedGrid];
    NSArray *resultPath = [self recoveryPathFromGrid:filledGrid];
    return resultPath;
}

- (NSArray *)prepareGrid {
    NSMutableArray *grid = [[NSMutableArray alloc] init];
    for (NSUInteger position = 0; position < self.gridBalls.allPositions; position++) {
        grid[position] = @([self.balls[position] isEqual:@1] ? kWall : kBlank);
    }
    return grid;
}

- (NSArray *)fillGrid:(NSArray *)sourceGrid {
    NSMutableArray *grid = [sourceGrid mutableCopy];
    NSInteger step = 0;
    grid[self.startPosition] = @(step);// стартовая ячейка помечена 0
    BOOL stop = NO;
    do {
        stop = YES; // предполагаем, что все свободные клетки уже помечены
        for (NSUInteger position = 0; position < self.gridBalls.allPositions; position++){
            if ([grid[position] isEqual:@(step)]) { // ячейка (x, y) помечена числом step
                NSArray *positionsOrientation = [self.gridBalls searchOrientingMovementsAroundSourcePosition:position];
                for (NSNumber *positionOrientation in positionsOrientation) {
                    if ([grid[positionOrientation.integerValue] isEqual:@(kBlank)]) {
                        stop = NO; // найдены непомеченные клетки
                        grid[positionOrientation.integerValue] = @(step + 1); // распространяем волну
                    }
                }
            }
        }
        step++;
    } while (!stop && [grid[self.endPosition] isEqual:@(kBlank)]);
    return grid;
}

- (NSArray *)recoveryPathFromGrid:(NSArray *)sourceGrid {
    NSMutableArray *grid = [sourceGrid mutableCopy];
    if ([grid[self.endPosition] isEqual:@(kBlank)]) {
        NSLog(@"путь не найден");
        return @[];
    }
    
    NSInteger lenghtPath = ((NSNumber *)grid[self.endPosition]).integerValue; // длина кратчайшего пути из startPosition в endPosition
    NSMutableArray *path = [[NSMutableArray alloc] init];
    for (NSInteger position = 0; position <= lenghtPath; position++) {
        [path addObject:@(0)];
    }
    NSInteger position = self.endPosition;
    NSInteger step = lenghtPath;
    while (step > 0) {
        path[step] = @(position);  // записываем ячейку (x, y) в путь
        step--;
        NSArray *orientationMovePosition = [self.gridBalls searchOrientingMovementsAroundSourcePosition:position];
        for (NSNumber *orientationPosition in orientationMovePosition) {
            if ([grid[orientationPosition.integerValue] isEqual:@(step)]) {
                position = orientationPosition.integerValue; // переходим в ячейку, которая на 1 ближе к старту
                break;
            }
        }
    }
    path[0] = @(self.startPosition); // теперь path[0..lenghtPath]  - координаты ячеек пути
    return path;
}

@end
