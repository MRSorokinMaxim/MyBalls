//
//  PresentViewController.h
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameView;
@class MulticoloredBallsViewModel;

@interface PresentViewController : UIViewController

@property (strong, nonatomic) GameView *gameView;
@property (strong, nonatomic) MulticoloredBallsViewModel *viewModel;

@end
