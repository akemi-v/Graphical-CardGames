//
//  SetCardDeck.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(id)init
{
    self = [super init];
    if (self) {
        for (NSString *symbol in [[SetCard class] validSymbols]) {
            for (NSUInteger number = 1; number <= 3; number++) {
                for (NSString *color in [[SetCard class] validColors]){
                    for (NSString *shading in [[SetCard class] validShadings]){
                        SetCard *card =[[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card atTop:YES];
                    }
                    
                }
            }
        }
    }
    return self;
}

@end
