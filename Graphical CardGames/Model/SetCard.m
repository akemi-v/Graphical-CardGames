//
//  SetCard.m
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray *)validSymbols
{
    return @[@"diamond", @"squiggle", @"oval"];
}

+ (NSArray *)validShadings
{
    return @[@"solid", @"striped", @"open"];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

+ (NSUInteger)maxNumber
{
    return 3;
}

-(void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

-(void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

-(void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) _number = number;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int symbolSum = 0;
    int numberSum = 0;
    int shadingSum = 0;
    int colorSum = 0;
    
    if (otherCards.count==3) {
        for (SetCard *otherCard in otherCards) {
            symbolSum+= [[SetCard validSymbols] indexOfObject:otherCard.symbol] + 1;
            numberSum+= otherCard.number;
            shadingSum+= [[SetCard validShadings] indexOfObject:otherCard.shading] + 1;
            colorSum+= [[SetCard validColors] indexOfObject:otherCard.color] + 1;
        }

        if ((symbolSum % 3 == 0) && (numberSum % 3 == 0) && (shadingSum % 3 == 0) && (colorSum % 3 == 0))
        {
            score = 1;
        }
    }
    return score;
}


- (NSString *) contents
{
    return nil;
}

-(NSString *)description

{
    NSDictionary *symbolPallette = @{@"diamond":@"▲",@"squiggle":@"■",@"oval":@"●"};
    NSString *text =  [@"" stringByPaddingToLength:self.number withString:symbolPallette[self.symbol] startingAtIndex:0];
    return [NSString stringWithFormat:@"%@ %@ %@ ", text, self.color,self.shading];
}

@end
