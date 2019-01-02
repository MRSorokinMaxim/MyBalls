//
//  MultiColorBall.h
//  Balls
//
//  Created by Максим Сорокин on 02.09.2018.
//  Copyright © 2018 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiColorBall : UIImageView

@property (nonatomic) CGPoint returnCentre;
@property (strong, nonatomic) NSString *imagePath;

- (instancetype)initWithimagePath:(NSString *)imagePath returnCentre:(CGPoint)returnCentre;

@end
