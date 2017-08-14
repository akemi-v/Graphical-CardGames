//
//  CardMatchingGame.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//


#import "CardMatchingGame.h"


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

@interface CardMatchingGame()

@property (nonatomic, readwrite) int score;
@property (nonatomic, strong) NSMutableArray *cards;  // of Card
@property (nonatomic, strong) NSMutableArray *faceUpCards;  // of Card
@property (readwrite, nonatomic) int lastFlipPoints;

@end

@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (int) matchBonus
{
    if (_matchBonus <= 0) _matchBonus = MATCH_BONUS;
    return _matchBonus;
}

- (int) mismatchPenalty
{
    if (_mismatchPenalty <= 0) _mismatchPenalty = MISMATCH_PENALTY;
    return _mismatchPenalty;
}

- (int) flipCost
{
    if (_flipCost <= 0) _flipCost = COST_TO_CHOOSE;
    return _flipCost;
}

- (NSUInteger)numOfCardsInGame
{
    return [self.cards count];
}

- (void)setNumberOfMatches:(NSUInteger)numberOfMatches
{
    _numberOfMatches = numberOfMatches >= 2 ? numberOfMatches :2;
}

-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen =NO;
        } else {
            self.faceUpCards= [[NSMutableArray alloc] initWithArray:@[card]];
            self.lastFlipPoints = 0;
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [self.faceUpCards insertObject:otherCard atIndex:0];
                    if ([self.faceUpCards count] == (self.numberOfMatches)) {
            
                        int matchScore = [card match:self.faceUpCards];
                        if (matchScore) {
                            self.lastFlipPoints = matchScore * self.matchBonus;
                            for (Card *faceUpCard in self.faceUpCards) {
                                faceUpCard.matched = YES;
                            }
                            
                        } else {
                            self.lastFlipPoints = - self.mismatchPenalty;
                            for (Card *faceUpCard in self.faceUpCards) {
                                if (faceUpCard != card) faceUpCard.chosen = NO;
                            }
                        }
                        self.matchedCards = [self.faceUpCards copy];
                        break;
                    }
                }
            }
            self.score += self.lastFlipPoints - self.flipCost;
            self.matchedCards = [self.faceUpCards copy];
            card.chosen = YES;
        }
    }
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)addCardToGame:(Card *)card
{
    [self.cards addObject:card];
}


-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        if (count < [deck deckSize]) {
            for (int i = 0; i < count; i++) {
                Card *card = [deck drawRandomCard];
                if (card) {
                    [self.cards addObject:card];
                } else {
                    self = nil;
                    break;
                }
            }
        }
    }
    return self;
}

@end
