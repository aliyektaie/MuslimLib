//
//  MainQuranViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/14/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "QuranPageView.h"

#define MODE_BOOK 0
#define MODE_ARABIC_ONLY 1
#define MODE_ARABIC_AND_TRANSLATION 2


@interface MainQuranViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet QuranPageView *quranPageViewer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *pagePosition;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currntSourah;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationFirstPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationPreviousPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationNextPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationLastPage;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cmdViews;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetSource;

@property (assign, nonatomic) int page;
@property (assign, nonatomic) BOOL saveCurrentPage;
@property (strong, nonatomic) NSArray* content;
@property (strong, nonatomic) NSArray* translations;
@property (assign, nonatomic) int mode;

- (void)setQuranPage:(int)page;

@end
