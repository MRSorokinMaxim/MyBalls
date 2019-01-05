//
//  ShortestPathAlgorithmTests.m
//  BallsTests
//
//  Created by Максим Сорокин on 04.01.2019.
//  Copyright © 2019 Максим Сорокин. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "ShortestPathAlgorithm.h"
#import "GridGameView.h"
#define EXP_SHORTHAND

@interface ShortestPathAlgorithm (Private)

@property (nonatomic, strong) NSArray *balls;
@property (strong, nonatomic) GridGameView *gridBalls;
@property (nonatomic) NSInteger startPosition;
@property (nonatomic) NSInteger endPosition;

@end

@interface GridGameView ()

@property (nonatomic) CGFloat widthGameView;
@property (nonatomic) CGFloat heightGameView;
@property (nonatomic) CGFloat widthBallView;
@property (nonatomic) CGFloat heightBallView;

@end

SpecBegin(ShortestPathAlgorithm);

describe(@"ShortestPathAlgorithm", ^{
    __block ShortestPathAlgorithm *algorithm = nil;
    __block GridGameView *gridGameView = nil;
    
    describe(@"Array without balls", ^{
        beforeEach(^{
            algorithm = [[ShortestPathAlgorithm alloc] init];
            gridGameView = [[GridGameView alloc] init];
            // Поле размером 5*4
            gridGameView.widthGameView = 20;
            gridGameView.widthBallView = 4;
            gridGameView.heightGameView = 16;
            gridGameView.heightBallView = 4;
            algorithm.gridBalls = gridGameView;
            
            NSMutableArray *balls = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < gridGameView.allPositions; i++) {
                [balls addObject:@(0)];
            }
            algorithm.balls = balls;
        });
        
        it(@"begin top from left to right diagonal test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 19;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@0,@4,@8,@12,@16,@17,@18,@19]);
        });
        
        it(@"begin bottom from left to right diagonal test", ^{
            algorithm.startPosition = 3;
            algorithm.endPosition = 16;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@3,@7,@11,@15,@19,@18,@17,@16]);
        });
        
        it(@"begin top from right to left diagonal test", ^{
            algorithm.startPosition = 13;
            algorithm.endPosition = 7;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@13,@9,@5,@6,@7]);
        });
        
        it(@"begin bottom from right to left diagonal test", ^{
            algorithm.startPosition = 19;
            algorithm.endPosition = 0;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@19,@15,@11,@7,@3,@2,@1,@0]);
        });
        
        it(@"straight on one line in height test", ^{
            algorithm.startPosition = 9;
            algorithm.endPosition = 11;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@9,@10,@11]);
        });
        
        it(@"reverse on one line in height test", ^{
            algorithm.startPosition = 15;
            algorithm.endPosition = 12;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@15,@14,@13,@12]);
        });
        
        it(@"straight on one line in width test", ^{
            algorithm.startPosition = 1;
            algorithm.endPosition = 17;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@1,@5,@9,@13,@17]);
        });
        
        it(@"reverse on one line in width test", ^{
            algorithm.startPosition = 15;
            algorithm.endPosition = 3;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@15,@11,@7,@3]);
        });
        
        afterEach(^{
            algorithm = nil;
            gridGameView = nil;
        });
    });
    
    describe(@"Array with balls - square array", ^{
        beforeEach(^{
            algorithm = [[ShortestPathAlgorithm alloc] init];
            // Поле размером 4*4
            gridGameView = [[GridGameView alloc] init];
            gridGameView.widthGameView = 16;
            gridGameView.widthBallView = 4;
            gridGameView.heightGameView = 16;
            gridGameView.heightBallView = 4;
            algorithm.gridBalls = gridGameView;
        });
        
        it(@"begin top from left to right diagonal with ball position = 13 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 15;
            algorithm.balls = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@1,@0,@0];
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@0,@4,@8,@9,@10,@14,@15]);
        });
        
        it(@"begin top from left to right diagonal with ball position = 3,10,14 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 15;
            algorithm.balls = @[@0,@0,@0,@1,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1,@0];
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@0,@4,@5,@6,@7,@11,@15]);
        });
        
        it(@"begin top from left to right diagonal with ball position = 8,9,10 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 12;
            algorithm.balls = @[@0,@0,@0,@0,@0,@0,@0,@0,@1,@1,@1,@0,@0,@0,@0,@0];
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@0,@4,@5,@6,@7,@11,@15,@14,@13,@12]);
        });
        
        it(@"begin top from left to right diagonal with ball position = 11,10,14 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 15;
            algorithm.balls = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@1,@1,@0,@0,@1,@0];
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[]);
        });
        
        afterEach(^{
            algorithm = nil;
            gridGameView = nil;
        });
    });
    describe(@"Array with balls - not square array", ^{
        beforeEach(^{
            algorithm = [[ShortestPathAlgorithm alloc] init];
            // Поле размером 11*9
            gridGameView = [[GridGameView alloc] init];
            gridGameView.widthGameView = 110;
            gridGameView.widthBallView = 10;
            gridGameView.heightGameView = 90;
            gridGameView.heightBallView = 10;
            algorithm.gridBalls = gridGameView;
        });
        
        it(@"hard 1 test", ^{
            algorithm.startPosition = 31;
            algorithm.endPosition = 69;
            NSMutableArray *balls = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < algorithm.gridBalls.allPositions; i++) {
                [balls addObject:@(0)];
            }
            balls[12] = @1;
            balls[13] = @1;
            balls[14] = @1;
            balls[23] = @1;
            balls[32] = @1;
            balls[36] = @1;
            balls[37] = @1;
            balls[38] = @1;
            balls[39] = @1;
            balls[40] = @1;
            balls[49] = @1;
            balls[60] = @1;
            balls[61] = @1;
            balls[62] = @1;
            balls[64] = @1;
            balls[65] = @1;
            balls[66] = @1;
            balls[67] = @1;
            balls[68] = @1;
            algorithm.balls = balls;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@31,@22,@21,@20,@11,@2,@3,@4,@5,@6,@15,@24,@33,@42,@51,@50,@59,@58,@57,@56,@55,@54,@63,@72,@73,@74,@75,@76,@77,@78,@69]);
        });
        
        it(@"hard 2 test", ^{
            
            algorithm.startPosition = 90;
            algorithm.endPosition = 44;
            NSMutableArray *balls = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < algorithm.gridBalls.allPositions; i++) {
                [balls addObject:@(0)];
            }
            balls[1] = @1;
            balls[11] = @1;
            balls[14] = @1;
            balls[15] = @1;
            balls[16] = @1;
            balls[21] = @1;
            balls[23] = @1;
            balls[32] = @1;
            balls[37] = @1;
            balls[38] = @1;
            balls[39] = @1;
            balls[40] = @1;
            balls[41] = @1;
            balls[42] = @1;
            balls[43] = @1;
            balls[52] = @1;
            balls[53] = @1;
            balls[54] = @1;
            balls[55] = @1;
            balls[56] = @1;
            balls[57] = @1;
            balls[58] = @1;
            balls[59] = @1;
            balls[63] = @1;
            balls[68] = @1;
            balls[72] = @1;
            balls[74] = @1;
            balls[75] = @1;
            balls[77] = @1;
            balls[81] = @1;
            balls[83] = @1;
            balls[93] = @1;
            algorithm.balls = balls;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@90,@91,@82,@73,@64,@65,@66,@67,@76,@85,@86,@87,@78,@69,@60,@51,@50,@49,@48,@47,@46,@45,@36,@27,@28,@29,@30,@31,@22,@13,@4,@5,@6,@7,@8,@17,@26,@35,@44]);
        });
        
        it(@"hard 3 is hard 2 diff some balls test", ^{
            algorithm.startPosition = 90;
            algorithm.endPosition = 44;
            NSMutableArray *balls = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < algorithm.gridBalls.allPositions; i++) {
                [balls addObject:@(0)];
            }
            balls[1] = @1;
            balls[11] = @1;
            balls[14] = @1;
            balls[15] = @1;
            balls[16] = @1;
            balls[21] = @1;
            balls[23] = @1;
            balls[37] = @1;
            balls[38] = @1;
            balls[39] = @1;
            balls[41] = @1;
            balls[42] = @1;
            balls[51] = @1;
            balls[53] = @1;
            balls[54] = @1;
            balls[55] = @1;
            balls[56] = @1;
            balls[57] = @1;
            balls[58] = @1;
            balls[59] = @1;
            balls[63] = @1;
            balls[68] = @1;
            balls[70] = @1;
            balls[71] = @1;
            balls[72] = @1;
            balls[74] = @1;
            balls[75] = @1;
            balls[77] = @1;
            balls[81] = @1;
            balls[83] = @1;
            balls[93] = @1;
            algorithm.balls = balls;
            NSArray *path = [algorithm calculatePath];
            expect(path).to.equal(@[@90,@91,@82,@73,@64,@65,@66,@67,@76,@85,@86,@87,@78,@69,@60,@61,@52,@43,@44]);
        });
        
        afterEach(^{
            algorithm = nil;
            gridGameView = nil;
        });
    });
});

SpecEnd
