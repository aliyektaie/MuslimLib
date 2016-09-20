//
//  QuranPagesIndexViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/16/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "PresentViewSegue.h"
#import "MainQuranViewController.h"

@interface QuranPagesIndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

+ (QuranPagesIndexViewController*)create;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainQuranViewController *quranPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cmdClose;

@end
