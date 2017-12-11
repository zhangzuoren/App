//
//  IconLabel.m
//  App
//
//  Created by zhangzuoren on 2017/4/17.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import "BaseIconLabel.h"

@interface BaseIconLabel ()
@property (nonatomic, weak) UIView  *oldIconView;
@end

@implementation BaseIconLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    UIEdgeInsets insets = self.edgeInsets;
    
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.height += (insets.top + insets.bottom);
    _iconView && [_iconView isKindOfClass:[UIView class]] ?
    (rect.size.width += (insets.left + insets.right + _gap + _iconView.frame.size.width)) :
    (rect.size.width += (insets.left + insets.right));
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    
    UIEdgeInsets insets = self.edgeInsets;
    
    if (self.iconView) {
        
        if (self.direction == kIconAtLeft) {
            
            _iconView.left    = insets.left;
            _iconView.centerY = CGRectGetHeight(self.bounds) / 2.f;
            insets = UIEdgeInsetsMake(insets.top, insets.left + _gap + _iconView.frame.size.width, insets.bottom, insets.right);
            
        } else if (self.direction == kIconAtRight) {
            
            _iconView.right   = self.width - insets.right;
            _iconView.centerY = CGRectGetHeight(self.bounds) / 2.f;
            insets = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom, insets.right  + _gap + _iconView.frame.size.width);
        }
    }
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)sizeToFitWithText:(NSString *)text {
    
    self.text = text;
    [self sizeToFit];
}

#pragma mark - setter & getter.

@synthesize iconView = _iconView;

- (void)setIconView:(UIView *)iconView {
    
    _oldIconView && [_oldIconView isKindOfClass:[UIView class]] ? ([_oldIconView removeFromSuperview]) : 0;
    
    _iconView    = iconView;
    _oldIconView = iconView;
    iconView.x   = 0.f;
    iconView.y   = 0.f;
    
    [self addSubview:iconView];
}

- (UIView *)iconView {
    
    return _iconView;
}

@end
