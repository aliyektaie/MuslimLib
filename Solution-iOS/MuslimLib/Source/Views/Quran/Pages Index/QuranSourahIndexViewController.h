//
//  QuranSourahIndexViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/2/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "MainQuranViewController.h"

@interface QuranSourahIndexViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cmdClose;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainQuranViewController *quranPage;
@property (strong, nonatomic) NSArray* sourahList;
@property (strong, nonatomic) NSMutableArray* searchResultSourahList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cmdOptions;

@property (weak, nonatomic) IBOutlet UIView *searchOverlay;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


+ (QuranSourahIndexViewController*)create;

@end
