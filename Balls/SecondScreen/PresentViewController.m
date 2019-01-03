//
//  PresentViewController.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "PresentViewController.h"

#import "GameView.h"
#import "MulticoloredBallsViewModel.h"

@interface PresentViewController () <GameViewDrawingDelegate>

@property (strong, nonatomic) GameView *gameView;

@property (strong, nonatomic) MulticoloredBallsViewModel *viewModel;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameView = [[GameView alloc] initWithFrame:self.view.bounds];
    self.gameView.delegate = self;
    [self.view addSubview:self.gameView];
    self.viewModel = [[MulticoloredBallsViewModel alloc] init];
}


#pragma mark - GameViewDrawingDelegate


- (void)start {
    [self.viewModel fillFreePositionsWithNumbers:self.gameView.subviews.count];
    [self addNewBallsOnGameView];
}

- (void)addNewBallsOnGameView {
    NSSet *freePositions = [self.viewModel searchFreePositionAmongNumbers:self.gameView.subviews.count];
    for (NSNumber *freePosition in freePositions) {
        NSString *pathImageBall = [self.viewModel randomImageNameBall];
        [self.gameView addBallOnPosition:freePosition.unsignedIntegerValue withPathImage:pathImageBall];
    }
}

- (void)freePosition:(NSUInteger)position {
    [self.viewModel addFreePosition:@(position)];
}

- (void)takePosition:(NSUInteger)position {
    [self.viewModel removeFreePosition:@(position)];
}



@end
