//
//  BoxBallView.m
//  Balls
//
//  Created by Максим Сорокин on 17.08.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import "BoxBallView.h"
#import "MultiColorBall.h"

@implementation BoxBallView

static NSUInteger const kCornerFontStandartHeight = 180;
static NSUInteger const kCornerRadius = 12;


#pragma mark - Draw


- (CGFloat)cornerScaleFactor {
    return CGRectGetHeight(self.bounds) / kCornerFontStandartHeight;
}

- (CGFloat)cornerRadius {
    return kCornerRadius * [self cornerScaleFactor];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundRect addClip];
    [UIColor.lightGrayColor setStroke];
    [roundRect stroke];
}


#pragma mark - Initialization


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
        self.mainBall = [[MultiColorBall alloc] initWithFrame:self.bounds];
        self.mainBall.returnCentre = self.center;
    }
    return self;
}

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}


#pragma mark - Public


- (void)createBallWithPathImage:(NSString *)pathBallImage {
    self.mainBall = [[MultiColorBall alloc] initWithFrame:self.bounds];
    self.mainBall.returnCentre = self.center;
    [self.mainBall addBallImageWithPath:pathBallImage];
    [self addSubview:self.mainBall.backgroundBall];
    [self addSubview:self.mainBall];
}

- (void)deleteBall {
    [self.mainBall removeFromSuperview];
    self.mainBall.backgroundBall.alpha = 0.6f;
}

- (void)determineBackgroundColorDependingOnTouchPoint:(CGPoint)touchPoint {
    if (CGRectContainsPoint(self.frame, touchPoint) && self.subviews.count) {
        self.backgroundColor = [UIColor redColor];
    }
    else if (CGRectContainsPoint(self.frame, touchPoint) && !self.subviews.count) {
        self.backgroundColor = [UIColor yellowColor];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
