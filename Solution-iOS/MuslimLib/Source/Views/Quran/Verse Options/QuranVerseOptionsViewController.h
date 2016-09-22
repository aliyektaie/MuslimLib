//
//  QuranVerseOptionsViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/22/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuranVerse.h"
#import <STPopup/STPopup.h>

@interface QuranVerseOptionsViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) QuranVerse* verse;
@property (strong, nonatomic) NSArray* items;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
