//
//  PlayingCardView.h
//  Graphical CardGames
//
//  Created by Apple on 8/7/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;


@end
