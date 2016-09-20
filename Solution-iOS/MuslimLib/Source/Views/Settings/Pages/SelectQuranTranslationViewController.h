//
//  SelectQuranTranslationViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectQuranTranslationViewController : BaseViewController <UITableViewDataSource>

@property (strong, nonatomic) NSArray* translations;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
