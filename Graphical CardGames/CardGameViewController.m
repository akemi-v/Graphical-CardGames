//
//  CardGameViewController.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//


#import "CardGameViewController.h"
#import "Deck.h"
#import "Grid.h"
#import "PlayingCard.h"
#import "SetCard.h"

@interface CardGameViewController ()

@property (strong, nonatomic) Deck *deck;
@property (nonatomic,strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *cardFieldView;
@property (strong, nonatomic) NSMutableArray *cardViews; // of CardViews
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) BOOL isPiled;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self startingNumberOfcards] usingDeck:[self createDeck]];
    _game.numberOfMatches =[self numberOfMatches];
    _game.gameName = [self gameName];
    return _game;
}

- (Grid *)grid
{
    _grid = [[Grid alloc] init];
    _grid.size = self.cardFieldView.bounds.size;
    _grid.cellAspectRatio = self.maxCardSize.width / self.maxCardSize.height;
    _grid.minimumNumberOfCells = self.game.numOfCardsInGame;
    _grid.maxCellWidth = self.maxCardSize.width;
    _grid.maxCellHeight = self.maxCardSize.height;
    return _grid;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardFieldView];
    return _animator;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [NSMutableArray arrayWithCapacity:self.startingNumberOfcards];
    return _cardViews;
}

- (UIView *)viewForCard:(Card *)card
{
    UIView *view = [[UIView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    view.backgroundColor = [UIColor redColor];
}

#define CELL_SCALE 0.05

- (void)updateUI
{
    for (NSUInteger cardIndex = 0; cardIndex < self.game.numOfCardsInGame; cardIndex++) {
        
        Card *card = [self.game cardAtIndex:cardIndex];
        NSUInteger viewIndex = [self.cardViews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                if (((UIView *)obj).tag == cardIndex) return YES;
            }
            return NO;
        }];
        UIView *cardView;
        if (viewIndex == NSNotFound) {
            if (!card.matched) {
                cardView = [self viewForCard:card];
                cardView.tag = cardIndex;
                cardView.frame = CGRectMake(self.cardFieldView.bounds.size.width,
                                            self.cardFieldView.bounds.size.height,
                                            self.grid.cellSize.width,
                                            self.grid.cellSize.height);
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCard:)];
                [cardView addGestureRecognizer:tap];
                
                [self.cardViews addObject:cardView];
                viewIndex = [self.cardViews indexOfObject:cardView];
                [self.cardFieldView addSubview:cardView];
            }
        } else {
            cardView = self.cardViews[viewIndex];
            if (!card.matched) {
                [self updateView:cardView forCard:card];
            } else {
                if (self.removeMatchingCards) {
                    [self.cardViews removeObject:cardView];
                    [UIView animateWithDuration:1.0
                                     animations:^{
                                         cardView.frame = CGRectMake(0.0,
                                                        self.cardFieldView.bounds.size.height,
                                                        self.grid.cellSize.width,
                                                        self.grid.cellSize.height);
                                         
                                     } completion:^(BOOL finished) {
                                         [cardView removeFromSuperview];
                                     }];
                } else {
                    cardView.alpha = card.matched ? 0.6 : 1.0;
                }
            }
        }
    }
    
    self.grid.minimumNumberOfCells = [self.cardViews count];
    
    NSUInteger changedViews = 0;
    for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CELL_SCALE, frame.size.height * CELL_SCALE);
        UIView *cardView = (UIView *)self.cardViews[viewIndex];
            [UIView animateWithDuration:0.5
                                  delay:1.5 * changedViews++ / [self.cardViews count]
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cardView.frame = frame;
                             } completion:NULL];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}


- (void)touchCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.game chooseCardAtIndex:gesture.view.tag];
        Card *card = [self.game cardAtIndex:gesture.view.tag];
        if ([card isKindOfClass:[PlayingCard class]]) {
            [UIView transitionWithView:gesture.view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^(void){
                                [self updateView:gesture.view forCard:card]; }
                            completion:^(BOOL finished) {
                                [self updateView:gesture.view forCard:card];
                                card.chosen = !card.chosen;
                                card.chosen = !card.chosen;
                                [self updateUI];
                            }];
        }
        [self updateUI];
    }
}

- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

 - (Deck *)createDeck
{
    return nil;
}

- (NSUInteger)numberOfMatches
{
    return 0;
}

- (NSString *)gameName
{
    return nil;
}

- (NSUInteger)startingNumberOfcards
{
    return 0;
}

- (IBAction)Deal
{
    self.game = nil;
    for (UIView *view in self.cardViews) {
        
        [UIView animateWithDuration:1.0
                         animations:^{
                             view.frame = CGRectMake(0.0,
                                        self.cardFieldView.bounds.size.height,
                                        self.grid.cellSize.width,
                                    self.grid.cellSize.height);
                             
                         } completion:^(BOOL finished) {
                             [view removeFromSuperview];
                             [self.cardViews removeObject:view];
                         }];
    }
    self.cardViews = nil;
    self.grid = nil;
    self.isPiled = NO;
    [self updateUI];
}

- (IBAction)addCardsFromDeck:(UIButton *)sender
{
    for (NSUInteger i = 0; i < sender.tag; i++) {
        if (self.deck.deckSize) {
            Card *card = self.deck.drawRandomCard;
            [self.game addCardToGame:card];

        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deck is empty" message:@"No more cards are available" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {} ];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    self.isPiled = NO;
    [self updateUI];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.grid.size = self.cardFieldView.bounds.size;
    [self updateUI];
}


- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    if (!self.isPiled) {
        for (UIView *view in self.cardViews) {
            [UIView animateWithDuration:1.0
                             animations:^{
                                 view.frame = CGRectMake(
                                            [sender locationInView:self.cardFieldView].x,
                                            [sender locationInView:self.cardFieldView].y,
                                            self.grid.cellSize.width,
                                            self.grid.cellSize.height);
                                 
                             } completion:NULL];
            
        }
        self.isPiled = YES;
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    if (self.isPiled) {
        for (UIView *view in self.cardViews) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 view.frame = CGRectMake(
                                            [sender locationInView:self.cardFieldView].x - self.grid.cellSize.width / 2,
                                            [sender locationInView:self.cardFieldView].y - self.grid.cellSize.height / 2,
                                            self.grid.cellSize.width,
                                            self.grid.cellSize.height);
                                 
                             } completion:NULL];

        }
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    if (self.isPiled) {
        NSUInteger changedViews = 0;
        for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
            CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                              inColumn:viewIndex % self.grid.columnCount];
            frame = CGRectInset(frame, frame.size.width * CELL_SCALE, frame.size.height * CELL_SCALE);
            UIView *cardView = (UIView *)self.cardViews[viewIndex];
            [UIView animateWithDuration:0.5
                                  delay:1.5 * changedViews++ / [self.cardViews count]
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cardView.frame = frame;
                             } completion:NULL];
        }

        self.isPiled = NO;
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isPiled = NO;
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.cardFieldView addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.cardFieldView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cardFieldView addGestureRecognizer:tapGestureRecognizer];
    
    [self updateUI];
}
@end
