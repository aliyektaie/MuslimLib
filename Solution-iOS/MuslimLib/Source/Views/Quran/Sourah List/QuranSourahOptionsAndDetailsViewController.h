//
//  QuranSourahOptionsAndDetailsViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "QuranSourahInfo.h"

@interface QuranSourahOptionsAndDetailsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

+ (QuranSourahOptionsAndDetailsViewController*)create:(QuranSourahInfo*)model;

@property (strong, nonatomic) QuranSourahInfo* sourahInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
