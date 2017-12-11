//
//  BaseIconLabel.h
//  ElevatorM
//
//  Created by zhangzuoren on 2017/6/15.
//  Copyright © 2017年 zhangzuoren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kIconAtLeft,
    kIconAtRight,
} EIconEdgeDirection;

@interface BaseIconLabel : UILabel

@property (nonatomic, strong) UIView             *iconView;
@property (nonatomic)         UIEdgeInsets        edgeInsets;
@property (nonatomic)         EIconEdgeDirection  direction;
@property (nonatomic)         CGFloat             gap;

- (void)sizeToFitWithText:(NSString *)text;
@end
