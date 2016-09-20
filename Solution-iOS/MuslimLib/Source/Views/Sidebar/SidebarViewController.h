//
//  SidebarViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/13/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SidebarViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) NSMutableArray* cells;
@property (weak, nonatomic) IBOutlet UITableView *tblItems;

- (UIColor*)getBackgroundTopColor;
- (UIColor*)getBackgroundBottomColor;

+ (SidebarViewController*) instance;

@end
