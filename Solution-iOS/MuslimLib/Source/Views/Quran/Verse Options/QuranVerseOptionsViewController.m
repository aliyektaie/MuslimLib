//
//  QuranVerseOptionsViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/22/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranVerseOptionsViewController.h"
#import "Utils.h"
#import "LanguageStrings.h"

#define CELL_IDENTIFIER @"verse_options_id"

@interface QuranVerseOptionsViewController ()

@end

@implementation QuranVerseOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[
                   @"QuranTab/ReadQuran/VerseOptions/Recite",
                   @"QuranTab/ReadQuran/VerseOptions/ViewWordByWordTranslation",
                   @"QuranTab/ReadQuran/VerseOptions/ViewVerseStructure",
                   @"QuranTab/ReadQuran/VerseOptions/Bookmark",
                   @"QuranTab/ReadQuran/VerseOptions/ViewCommentary",
                   ];

    self.title = L(@"QuranTab/ReadQuran/VerseOptions/Title");
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.textLabel.text = L([self.items objectAtIndex:indexPath.row]);
    cell.textLabel.font = [Utils createDefaultFont:14];
    
    return cell;
}


@end
