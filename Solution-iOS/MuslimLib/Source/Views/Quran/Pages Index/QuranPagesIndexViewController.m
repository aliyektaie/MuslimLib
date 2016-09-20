//
//  QuranPagesIndexViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/16/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranPagesIndexViewController.h"
#import "Utils.h"
#import "Theme.h"
#import "QuranPageIndexCell.h"
#import "MainQuranViewController.h"
#import "LanguageStrings.h"

#define CELL_IDENTIFIER @"quran_pages_index_cell"

@interface QuranPagesIndexViewController () {
    UIViewController* _ppBlabla;
}

@end

@implementation QuranPagesIndexViewController

+ (QuranPagesIndexViewController*)create {
    return (QuranPagesIndexViewController*)[Utils createViewControllerFromStoryboard:@"QuranPagesIndexViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[QuranPageIndexCell class] forCellReuseIdentifier:CELL_IDENTIFIER];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.title = L(@"QuranTab/SelectQuranPage/Title");
    self.cmdClose.title = L(@"Close");

    [self.cmdClose setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [Utils createDefaultFont:16], NSFontAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
}

- (UIColor*)getBackgroundTopColor {
    return  [[Theme instance] lightPageGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return  [[Theme instance] lightPageGradientBottomColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 604;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuranPageIndexCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[QuranPageIndexCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER];
    }

    cell.page = (int)indexPath.row + 1;

    return cell;
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.quranPage setQuranPage:(int)indexPath.row + 1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
