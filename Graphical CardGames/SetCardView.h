//
//  SetCardView.h
//  Graphical CardGames
//
//  Created by Apple on 8/8/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic) NSUInteger number;
@property (nonatomic,strong) NSString *symbol;
@property (nonatomic,strong) NSString *shading;
@property (nonatomic,strong) NSString *color;
@property (nonatomic) BOOL chosen;

@end
