//
//  LoginTextField.m
//  App
//
//  Created by zhangzuoren on 2017/1/10.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

- (void)drawRect:(CGRect)rect {
    
    // Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the line color and width
    CGContextSetStrokeColorWithColor(
                                     context,
                                     [UIColor colorWithWhite:0.9 alpha:0.8].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    // Start a new Path
    CGContextBeginPath(context);
    
    // Find the number of lines in our textView + add a bit more height to draw
    // lines in the empty part of the view
    // NSUInteger numberOfLines = (self.contentSize.height +
    // self.bounds.size.height) / self.font.leading;
    
    // Set the line offset from the baseline. (I'm sure there's a concrete way to
    // calculate this.)
    CGFloat baselineOffset = 40.0f;
    
    // iterate over numberOfLines and draw each line
    // for (int x = 1; x < numberOfLines; x++) {
    
    // 0.5f offset lines up line with pixel boundary
    CGContextMoveToPoint(context, self.bounds.origin.x, baselineOffset);
    CGContextAddLineToPoint(context, self.bounds.size.width, baselineOffset);
    //}
    
    // Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);
}
- (void)drawPlaceholderInRect:(CGRect)rect{
    // 设置富文本属性
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.font;
    dictM[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    CGPoint point = CGPointMake(0, (rect.size.height - self.font.lineHeight) * 0.5);
    
    [self.placeholder drawAtPoint:point withAttributes:dictM];
}

@end
