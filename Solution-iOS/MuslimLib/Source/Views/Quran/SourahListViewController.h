//
//  SourahListViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/4/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabItemViewController.h"


@interface SourahListViewController : BaseTabItemViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray* sourahList;
@property (strong, nonatomic) NSMutableArray* searchResultSourahList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchOverlay;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
