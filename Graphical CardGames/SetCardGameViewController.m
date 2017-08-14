//
//  SetCardGameViewController.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)numberOfMatches
{
    return 3;
}

- (NSString *)gameName
{
    return @"Set";
}

- (NSUInteger)startingNumberOfcards
{
    return 12;
}

- (UIView *)viewForCard:(Card *)card
{
    SetCardView *view = [[SetCardView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]] && [view isKindOfClass:[SetCardView class]]) {
        SetCard *setCard = (SetCard *)card;
        SetCardView *setCardView = (SetCardView *)view;
        setCardView.color = setCard.color;
        setCardView.symbol = setCard.symbol;
        setCardView.shading = setCard.shading;
        setCardView.number = setCard.number;
        setCardView.chosen = setCard.chosen;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.removeMatchingCards = YES;
    [self updateUI];
}


@end
