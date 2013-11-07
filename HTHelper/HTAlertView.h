//
//  HTAlertView.h
//  
//
//  Created by 任健生 on 13-5-14.
//
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger);  

@interface HTAlertView : UIAlertView<UIAlertViewDelegate>

@property(nonatomic,copy) AlertBlock block;
@property(nonatomic,strong) UIView *customView;
@property(nonatomic) float customViewOffsetY;


@end
