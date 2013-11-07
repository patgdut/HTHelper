//
//  HTAlertView.m
//  
//
//  Created by 任健生 on 13-5-14.
//
//

#import "HTAlertView.h"

@implementation HTAlertView

- (void)setBlock:(AlertBlock)block {
    self.delegate = self;
    if (_block) {
        _block = nil;
    }
    _block = [block copy];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block) {
        self.block(buttonIndex);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    if (self.customView) {
        
        if (IOS7) {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:self.customView];
            self.customView.center = CGPointMake(window.width / 2, window.height / 2 - 22.0f + self.customViewOffsetY);
            self.customView.alpha = 0.0f;
            self.customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            [UIView animateWithDuration:0.3 animations:^{
                self.customView.alpha = 1.0f;
                self.customView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self addSubview:self.customView];
            self.customView.center = CGPointMake(self.width / 2, self.height / 2 - 22.0f + self.customViewOffsetY);
        }
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.customView) {
        if (IOS7) {
            [UIView animateWithDuration:0.3 animations:^{
                self.customView.alpha = 0.0f;
                self.customView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            } completion:^(BOOL finished) {
                [self.customView removeFromSuperview];
            }];
        }
    }
    
}

@end
