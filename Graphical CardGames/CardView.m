//
//  CardView.m
//  Graphical CardGames
//
//  Created by Apple on 8/8/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


@end
