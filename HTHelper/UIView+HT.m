//
//  UIView+HT.m
//  
//
//  Created by 任健生 on 13-3-4.
//
//

#import "UIView+HT.h"

@implementation UIView (HT)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    return curve << 16;
}

+ (UIViewAnimationOptions)keyboardAnimationOptions {
    return IOS7 ? 7 << 16 : 0;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}




@end
