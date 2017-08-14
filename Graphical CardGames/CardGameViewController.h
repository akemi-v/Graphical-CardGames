//
//  CardGameViewController.h
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck;
- (NSUInteger)numberOfMatches;
- (NSString *)gameName;
- (NSUInteger)startingNumberOfcards;
- (void)updateUI;
- (UIView *)viewForCard:(Card *)card;
- (void)updateView:(UIView *)view forCard:(Card *)card;


@property (nonatomic) CGSize maxCardSize;
@property (nonatomic) BOOL removeMatchingCards;



@end
