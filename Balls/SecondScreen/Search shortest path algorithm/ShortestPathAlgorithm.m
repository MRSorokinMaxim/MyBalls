//
//  ShortestPathAlgorithm.m
//  Balls
//
//  Created by Максим Сорокин on 04.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import "ShortestPathAlgorithm.h"

@interface ShortestPathAlgorithm ()

@property (nonatomic, strong) NSArray *gridBalls;
@property (nonatomic) NSInteger countBallOnWidth;
@property (nonatomic) NSInteger countBallOnHeight;

@property (nonatomic) NSInteger startPosition;
@property (nonatomic) NSInteger endPosition;

@end

@implementation ShortestPathAlgorithm

static const NSInteger kWall = -1;
static const NSInteger kBlank = -2;


- (NSMutableArray *)start {
    NSUInteger grid[self.countBallOnWidth * self.countBallOnHeight];
    for (NSUInteger index = 0; index < self.gridBalls.count; index++) {
        grid[index] = [self.gridBalls[index] isEqual:@1] ? kWall : kBlank;
    }
    
    grid[self.startPosition] = 0;// стартовая ячейка помечена 0
    
    int d, y, k;
    bool stop;
    d = 0;
    
    do {
        stop = true;               // предполагаем, что все свободные клетки уже помечены
        for (y = 0; y < self.countBallOnWidth * self.countBallOnHeight; y++){
            if (grid[y] == d) {                         // ячейка (x, y) помечена числом d
                int a=y+1,b=y-1;
                if (y % self.countBallOnHeight == self.countBallOnHeight - 1) a=-1;
                if (y % self.countBallOnHeight == 0) b=-1;
                int orientationMove[4] = {a, b, y + self.countBallOnHeight, y - self.countBallOnHeight};
                
                for (k = 0; k < 4; ++k) {                  // проходим по всем непомеченным соседям
                    if (orientationMove[k] >= 0 && orientationMove[k] < (self.countBallOnWidth * self.countBallOnHeight) && grid[orientationMove[k]] == kBlank){
                        stop = false;              // найдены непомеченные клетки
                        grid[orientationMove[k]] = d + 1;      // распространяем волну
                    }
                }
            }
        }
        d++;
    } while ( !stop && grid[self.endPosition] == kBlank );
    
    if (grid[self.endPosition] == kBlank) NSLog(@"путь не найден");
    
    // восстановление пути
    int px[self.countBallOnWidth * self.countBallOnHeight];
    
    int len = grid[self.endPosition];            // длина кратчайшего пути из self.startPosition в self.endPosition
    int x = self.endPosition;
    d = len;
    while (d > 0) {
        px[d] = x;  // записываем ячейку (x, y) в путь
        d--;
        for (k = 0; k < 4; ++k) {
            int a = x + 1, b = x - 1;
            if (x % self.countBallOnHeight == self.countBallOnHeight - 1) a=-1;
            if (x % self.countBallOnHeight == 0) b=-1;
            int orientationMove [4] = {a, b, x + self.countBallOnHeight, x - self.countBallOnHeight};
            if (orientationMove[k] >= 0 && orientationMove[k] < (self.countBallOnWidth * self.countBallOnHeight) && grid[orientationMove[k]] == d){
                x = orientationMove[k]; // переходим в ячейку, которая на 1 ближе к старту
                break;
            }
        }
    }
    px[0] = self.startPosition;                   // теперь px[0..len]  - координаты ячеек пути
    
    NSMutableArray *arrayCoordinate = [[NSMutableArray alloc]init];
    for(int i = 0; i <= len; i++){
        [arrayCoordinate addObject:@(px[i])];
    }
    return arrayCoordinate;
}

@end
