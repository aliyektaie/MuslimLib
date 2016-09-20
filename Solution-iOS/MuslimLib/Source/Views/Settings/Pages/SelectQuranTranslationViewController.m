//
//  SelectQuranTranslationViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/10/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "SelectQuranTranslationViewController.h"
#import "LanguageStrings.h"
#import "Theme.h"
#import "MuslimLib.h"
#import "TableViewImageLabelSwitchCell.h"

#define CELL_IDENTIFIER @"cell_for_available_translations"

@interface SelectQuranTranslationViewController ()

@end

@implementation SelectQuranTranslationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = L(@"SettingsPage/Settings/Quran/Translations");
    self.translations = [[MuslimLib instance] getQuranAvailableTranslations];
    
    [self.tableView registerClass:[TableViewImageLabelSwitchCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.tableView.dataSource = self;
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (UIColor*)getBackgroundTopColor {
    return  [Theme instance].lightPageGradientTopColor;
}

- (UIColor*)getBackgroundBottomColor {
    return  [Theme instance].lightPageGradientBottomColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.translations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewImageLabelSwitchCell* cell = (TableViewImageLabelSwitchCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TableViewImageLabelSwitchCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.model = [self.translations objectAtIndex:indexPath.row];
    
    return cell;
}

@end
