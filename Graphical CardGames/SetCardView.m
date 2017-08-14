//
//  SetCardView.m
//  Graphical CardGames
//
//  Created by Apple on 8/8/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma rank - Properties

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 0.1

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    if (self.chosen) {
        [[UIColor colorWithWhite:0.3 alpha:0.5] setFill];
        UIRectFill(self.bounds);
        roundedRect.lineWidth *= 2.0;
    } else {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
        roundedRect.lineWidth /= 2.0;
    }
    
    [self drawCard];
}

#pragma rank - Card

#define SYMBOL_OFFSET 0.2;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawCard
{
    UIColor * color;
    if ([self.color isEqualToString:@"red"]) color = [UIColor redColor];
    else if ([self.color isEqualToString:@"green"]) color = [UIColor greenColor];
    else if ([self.color isEqualToString:@"purple"]) color = [UIColor purpleColor];
    [color setStroke];
    CGPoint point = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (self.number == 1) {
        [self drawSymbolAtPoint:point];
        return;
    }
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(point.x - dx / 2, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx / 2, point.y)];
        return;
    }
    if (self.number == 3) {
        [self drawSymbolAtPoint:point];
        [self drawSymbolAtPoint:CGPointMake(point.x - dx, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx, point.y)];
        return;
    }
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ([self.symbol isEqualToString:@"oval"]) [self drawOvalAtPoint:point];
    else if ([self.symbol isEqualToString:@"squiggle"]) [self drawSquiggleAtPoint:point];
    else if ([self.symbol isEqualToString:@"diamond"]) [self drawDiamondAtPoint:point];
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4

- (void)drawOvalAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2.0 * dx, 2.0 * dy)
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

- (void)drawSquiggleAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2.0;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5

- (void)shadePath:(UIBezierPath *)path
{
    UIColor * color;
    if ([self.color isEqualToString:@"red"]) color = [UIColor redColor];
    else if ([self.color isEqualToString:@"green"]) color = [UIColor greenColor];
    else if ([self.color isEqualToString:@"purple"]) color = [UIColor purpleColor];
    if ([self.shading isEqualToString:@"solid"]) {
        [color setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"striped"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_LINE_WIDTH;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    } else if ([self.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
    }
}


@end
