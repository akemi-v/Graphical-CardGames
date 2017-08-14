//
//  SetCard.h
//  Graphical CardGames
//
//  Created by Apple on 8/3/17.
//  Copyright © 2017 Mari. All rights reserved.
//


#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic,strong) NSString *symbol;
@property (nonatomic,strong) NSString *shading;
@property (nonatomic,strong) NSString *color;

+(NSArray *)validSymbols;
+(NSArray *)validShadings;
+(NSArray *)validColors;
+(NSUInteger)maxNumber;

@end
