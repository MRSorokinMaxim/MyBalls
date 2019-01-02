//
//  GameView.h
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameViewDrawingDelegate

- (void)start;

@end

@interface GameView : UIView

@property (assign, nonatomic) id <GameViewDrawingDelegate> delegate;

@end
