//
//  PlayingCardGameViewController.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"


@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfMatches
{
    return 2;
}

- (NSString *)gameName
{
    return @"Matchismo";
}

- (NSUInteger)startingNumberOfcards
{
    return 20;
}

- (UIView *)viewForCard:(Card *)card
{
    PlayingCardView *view = [[PlayingCardView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    if ([card isKindOfClass:[PlayingCard class]] && [view isKindOfClass:[PlayingCardView class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        PlayingCardView *playingCardView = (PlayingCardView *)view;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
        playingCardView.faceUp = playingCard.chosen;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    self.removeMatchingCards = NO;
    [self updateUI];
}

@end
