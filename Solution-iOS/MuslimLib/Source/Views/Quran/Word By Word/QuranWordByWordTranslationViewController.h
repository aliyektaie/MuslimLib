//
//  QuranWordByWordTranslationViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/26/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "QuranVerse.h"

@interface QuranWordByWordTranslationViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

+ (QuranWordByWordTranslationViewController*)create:(QuranVerse*)verse;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) QuranVerse* verseInfo;
@property (strong, nonatomic) NSArray* words;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cmdClose;

@end
