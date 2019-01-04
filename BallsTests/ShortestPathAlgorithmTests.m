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

#define EXP_SHORTHAND

@interface ShortestPathAlgorithm (Private)

@property (nonatomic, strong) NSMutableArray *gridBalls;
@property (nonatomic) NSInteger countBallOnWidth;
@property (nonatomic) NSInteger countBallOnHeight;

@property (nonatomic) NSInteger startPosition;
@property (nonatomic) NSInteger endPosition;

@end

SpecBegin(ShortestPathAlgorithm);

describe(@"ShortestPathAlgorithm", ^{
    __block ShortestPathAlgorithm *algorithm = nil;
    
    beforeEach(^{

    });
    describe(@"Array without balls", ^{
        beforeEach(^{
            algorithm = [[ShortestPathAlgorithm alloc] init];
            algorithm.countBallOnWidth = 5;
            algorithm.countBallOnHeight = 4;
            NSMutableArray *gridBalls = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < algorithm.countBallOnWidth * algorithm.countBallOnHeight; i++) {
                [gridBalls addObject:@(0)];
            }
            algorithm.gridBalls = gridBalls;
        });
        
        it(@"begin top from left to right diagonal test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 19;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@0,@4,@8,@12,@16,@17,@18,@19]);
        });
        
        it(@"begin bottom from left to right diagonal test", ^{
            algorithm.startPosition = 3;
            algorithm.endPosition = 16;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@3,@7,@11,@15,@19,@18,@17,@16]);
        });
        
        it(@"begin top from right to left diagonal test", ^{
            algorithm.startPosition = 13;
            algorithm.endPosition = 7;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@13,@9,@5,@6,@7]);
        });
        
        it(@"begin bottom from right to left diagonal test", ^{
            algorithm.startPosition = 19;
            algorithm.endPosition = 0;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@19,@15,@11,@7,@3,@2,@1,@0]);
        });
        
        it(@"straight on one line in height test", ^{
            algorithm.startPosition = 9;
            algorithm.endPosition = 11;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@9,@10,@11]);
        });
        
        it(@"reverse on one line in height test", ^{
            algorithm.startPosition = 15;
            algorithm.endPosition = 12;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@15,@14,@13,@12]);
        });
        
        it(@"straight on one line in width test", ^{
            algorithm.startPosition = 1;
            algorithm.endPosition = 17;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@1,@5,@9,@13,@17]);
        });
        
        it(@"reverse on one line in width test", ^{
            algorithm.startPosition = 15;
            algorithm.endPosition = 3;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@15,@11,@7,@3]);
        });
        
        afterEach(^{
            algorithm = nil;
        });
    });
    
    describe(@"Array with balls - square array", ^{
        beforeEach(^{
            algorithm = [[ShortestPathAlgorithm alloc] init];
            algorithm.countBallOnWidth = 4;
            algorithm.countBallOnHeight = 4;
        });
        
        it(@"begin top from left to right diagonal with ball position = 13 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 15;
            NSMutableArray *gridBalls = [@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@1,@0,@0] mutableCopy];
            algorithm.gridBalls = gridBalls;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@0,@4,@8,@9,@10,@14,@15]);
        });
        
        it(@"begin top from left to right diagonal with ball position = 3,10,14 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 15;
            NSMutableArray *gridBalls = [@[@0,@0,@0,@1,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1,@0] mutableCopy];
            algorithm.gridBalls = gridBalls;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@0,@4,@5,@6,@7,@11,@15]);
        });
        
        it(@"begin top from left to right diagonal with ball position = 8,9,10 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 12;
            NSMutableArray *gridBalls = [@[@0,@0,@0,@0,@0,@0,@0,@0,@1,@1,@1,@0,@0,@0,@0,@0] mutableCopy];
            algorithm.gridBalls = gridBalls;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@0,@4,@5,@6,@7,@11,@15,@14,@13,@12]);
        });
        
        it(@"begin top from left to right diagonal with ball position = 11,10,14 test", ^{
            algorithm.startPosition = 0;
            algorithm.endPosition = 15;
            NSMutableArray *gridBalls = [@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@1,@1,@0,@0,@1,@0] mutableCopy];
            algorithm.gridBalls = gridBalls;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[]);
        });
        
        afterEach(^{
            algorithm = nil;
        });
    });
    describe(@"Array with balls - not square array", ^{
        beforeEach(^{
            algorithm = [[ShortestPathAlgorithm alloc] init];
            algorithm.countBallOnWidth = 11;
            algorithm.countBallOnHeight = 9;
            NSMutableArray *gridBalls = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < algorithm.countBallOnWidth * algorithm.countBallOnHeight; i++) {
                [gridBalls addObject:@(0)];
            }
            algorithm.gridBalls = gridBalls;
        });
        
        it(@"hard 1 test", ^{
            algorithm.startPosition = 31;
            algorithm.endPosition = 69;
            algorithm.gridBalls[12] = @1;
            algorithm.gridBalls[13] = @1;
            algorithm.gridBalls[14] = @1;
            algorithm.gridBalls[23] = @1;
            algorithm.gridBalls[32] = @1;
            algorithm.gridBalls[36] = @1;
            algorithm.gridBalls[37] = @1;
            algorithm.gridBalls[38] = @1;
            algorithm.gridBalls[39] = @1;
            algorithm.gridBalls[40] = @1;
            algorithm.gridBalls[49] = @1;
            algorithm.gridBalls[60] = @1;
            algorithm.gridBalls[61] = @1;
            algorithm.gridBalls[62] = @1;
            algorithm.gridBalls[64] = @1;
            algorithm.gridBalls[65] = @1;
            algorithm.gridBalls[66] = @1;
            algorithm.gridBalls[67] = @1;
            algorithm.gridBalls[68] = @1;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@31,@22,@21,@20,@11,@2,@3,@4,@5,@6,@15,@24,@33,@42,@51,@50,@59,@58,@57,@56,@55,@54,@63,@72,@73,@74,@75,@76,@77,@78,@69]);
        });
        
        it(@"hard 2 test", ^{
            algorithm.startPosition = 90;
            algorithm.endPosition = 44;
            algorithm.gridBalls[1] = @1;
            algorithm.gridBalls[11] = @1;
            algorithm.gridBalls[14] = @1;
            algorithm.gridBalls[15] = @1;
            algorithm.gridBalls[16] = @1;
            algorithm.gridBalls[21] = @1;
            algorithm.gridBalls[23] = @1;
            algorithm.gridBalls[32] = @1;
            algorithm.gridBalls[37] = @1;
            algorithm.gridBalls[38] = @1;
            algorithm.gridBalls[39] = @1;
            algorithm.gridBalls[40] = @1;
            algorithm.gridBalls[41] = @1;
            algorithm.gridBalls[42] = @1;
            algorithm.gridBalls[43] = @1;
            algorithm.gridBalls[52] = @1;
            algorithm.gridBalls[53] = @1;
            algorithm.gridBalls[54] = @1;
            algorithm.gridBalls[55] = @1;
            algorithm.gridBalls[56] = @1;
            algorithm.gridBalls[57] = @1;
            algorithm.gridBalls[58] = @1;
            algorithm.gridBalls[59] = @1;
            algorithm.gridBalls[63] = @1;
            algorithm.gridBalls[68] = @1;
            algorithm.gridBalls[72] = @1;
            algorithm.gridBalls[74] = @1;
            algorithm.gridBalls[75] = @1;
            algorithm.gridBalls[77] = @1;
            algorithm.gridBalls[81] = @1;
            algorithm.gridBalls[83] = @1;
            algorithm.gridBalls[93] = @1;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@90,@91,@82,@73,@64,@65,@66,@67,@76,@85,@86,@87,@78,@69,@60,@51,@50,@49,@48,@47,@46,@45,@36,@27,@28,@29,@30,@31,@22,@13,@4,@5,@6,@7,@8,@17,@26,@35,@44]);
        });
        
        it(@"hard 3 is hard 2 diff some balls test", ^{
            algorithm.startPosition = 90;
            algorithm.endPosition = 44;
            algorithm.gridBalls[1] = @1;
            algorithm.gridBalls[11] = @1;
            algorithm.gridBalls[14] = @1;
            algorithm.gridBalls[15] = @1;
            algorithm.gridBalls[16] = @1;
            algorithm.gridBalls[21] = @1;
            algorithm.gridBalls[23] = @1;
            algorithm.gridBalls[37] = @1;
            algorithm.gridBalls[38] = @1;
            algorithm.gridBalls[39] = @1;
            algorithm.gridBalls[41] = @1;
            algorithm.gridBalls[42] = @1;
            algorithm.gridBalls[51] = @1;
            algorithm.gridBalls[53] = @1;
            algorithm.gridBalls[54] = @1;
            algorithm.gridBalls[55] = @1;
            algorithm.gridBalls[56] = @1;
            algorithm.gridBalls[57] = @1;
            algorithm.gridBalls[58] = @1;
            algorithm.gridBalls[59] = @1;
            algorithm.gridBalls[63] = @1;
            algorithm.gridBalls[68] = @1;
            algorithm.gridBalls[70] = @1;
            algorithm.gridBalls[71] = @1;
            algorithm.gridBalls[72] = @1;
            algorithm.gridBalls[74] = @1;
            algorithm.gridBalls[75] = @1;
            algorithm.gridBalls[77] = @1;
            algorithm.gridBalls[81] = @1;
            algorithm.gridBalls[83] = @1;
            algorithm.gridBalls[93] = @1;
            NSArray *path = algorithm.start;
            expect(path).to.equal(@[@90,@91,@82,@73,@64,@65,@66,@67,@76,@85,@86,@87,@78,@69,@60,@61,@52,@43,@44]);
        });
        
        afterEach(^{
            algorithm = nil;
        });
    });
});

SpecEnd
