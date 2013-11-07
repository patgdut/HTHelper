//
//  UIView+HT.h
//  
//
//  Created by 任健生 on 13-3-4.
//
//

#import <UIKit/UIKit.h>

@interface UIView (HT)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;

- (void)setTop:(CGFloat)top;
- (void)setLeft:(CGFloat)left;

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;
+ (UIViewAnimationOptions)keyboardAnimationOptions;

@end

@interface UIView (Private)

- (NSString *)recursiveDescription;

@end
