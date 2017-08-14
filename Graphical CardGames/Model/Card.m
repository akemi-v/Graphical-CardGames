//
//  Card.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end

@implementation Card

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

 -(NSString *)description
{
    return self.contents;
}
@end
