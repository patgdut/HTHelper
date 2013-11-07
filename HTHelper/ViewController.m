//
//  ViewController.m
//  HTHelper
//
//  Created by 任健生 on 13-11-7.
//  Copyright (c) 2013年 test. All rights reserved.
//

#import "ViewController.h"
#import "HTAlertView.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"HTHelper";
    self.dataSource = [NSMutableArray array];
	[self.dataSource addObject:@"Prevent NSArray out of bounds"];
    [self.dataSource addObject:@"Prevent NSMutableDictionary set nil value"];
    [self.dataSource addObject:@"iOS7 Custom AlertView"];
    [self.dataSource addObject:@"Memory usage"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HTHelper";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            NSArray *array = @[@"0"];
            [array objectAtIndex:2];
            
            NSMutableArray *array2 = [NSMutableArray arrayWithArray:array];
            [array2 insertObject:nil atIndex:0];
            [array2 insertObject:@"1" atIndex:2];
        }
            break;
        case 1: {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:nil forKey:@"key"];
            [dict setObject:@"object" forKey:nil];
        }
            break;
        case 2: {
            HTAlertView *alertView = [[HTAlertView alloc] initWithTitle:@"\n\n\n"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 20.0f)];
            label.text = @"Custom AlertView in iOS7";
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter;
            alertView.customView = label;
            alertView.block = ^(NSInteger index) {
                NSLog(@"index:%li click",(long)index);
            };
            [alertView show];
        }
            break;
        case 3: {
            NSLog(@"Current Memory Usage:%@",[[UIDevice currentDevice] memoryUsage]);
        }
            break;
        default:
            break;
    }
}

@end
