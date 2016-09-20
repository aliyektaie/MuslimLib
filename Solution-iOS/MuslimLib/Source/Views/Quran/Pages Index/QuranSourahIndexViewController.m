//
//  QuranSourahIndexViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/2/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranSourahIndexViewController.h"
#import "Utils.h"
#import "LanguageStrings.h"
#import "QuranSourahInfo.h"
#import "QuranSourahListCell.h"
#import "NSString+Contains.h"
#import "MuslimLib.h"

#define CELL_IDENTIFIER @"quran_sourah_list_cell"

@implementation QuranSourahIndexViewController

+ (QuranSourahIndexViewController*)create {
    return (QuranSourahIndexViewController*)[Utils createViewControllerFromStoryboard:@"QuranSourahIndexViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sourahList = [[MuslimLib instance] getSourahList];
    self.searchResultSourahList = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.sourahList.count; i++) {
        [self.searchResultSourahList addObject:[self.sourahList objectAtIndex:i]];
    }

    [self.tableView registerClass:[QuranSourahListCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.title = L(@"QuranTab/SelectQuranSourah/Title");
    self.cmdClose.title = L(@"Close");

    [self.cmdClose setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [Utils createDefaultFont:16], NSFontAttributeName,
                                           nil]
                                 forState:UIControlStateNormal];

    self.cmdOptions.title = L(@"QuranTab/SourahList/Details/NavigationOption");

    [self.cmdOptions setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [Utils createDefaultFont:16], NSFontAttributeName,
                                           nil]
                                 forState:UIControlStateNormal];

    self.searchBar.delegate = self;
    self.searchOverlay.hidden = YES;

    self.searchOverlay.userInteractionEnabled = YES;
    [self.searchOverlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSearchOverlayTouch:)]];

}

- (IBAction)onCloseTouch:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onOptionsTouch:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:L(@"QuranTab/SourahList/Details/Actions/Title") message:L(@"QuranTab/SourahList/Details/Actions/Message") preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"QuranTab/SourahList/Details/Actions/Standard") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sortByBookOrder];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"QuranTab/SourahList/Details/Actions/Chronological") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sortByChronologicalOrder];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)sortByBookOrder {
    self.sourahList = [self sortArrayByBookOrder:self.sourahList];
    self.searchResultSourahList = [self sortArrayByBookOrder:self.searchResultSourahList];

    [self.tableView reloadData];
}

- (NSMutableArray*)sortArrayByBookOrder:(NSArray*)array {
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        QuranSourahInfo* first = (QuranSourahInfo*)a;
        QuranSourahInfo* second = (QuranSourahInfo*)b;

        if (first.orderInBook == second.orderInBook)
            return NSOrderedSame;

        if (first.orderInBook > second.orderInBook)
            return NSOrderedDescending;

        return NSOrderedAscending;
    }];

    return [sortedArray mutableCopy];
}

- (void)sortByChronologicalOrder {
    self.sourahList = [self sortArrayByChronologicalOrder:self.sourahList];
    self.searchResultSourahList = [self sortArrayByChronologicalOrder:self.searchResultSourahList];

    [self.tableView reloadData];
}

- (NSMutableArray*)sortArrayByChronologicalOrder:(NSArray*)array {
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        QuranSourahInfo* first = (QuranSourahInfo*)a;
        QuranSourahInfo* second = (QuranSourahInfo*)b;

        if (first.orderInReception == second.orderInReception)
            return NSOrderedSame;

        if (first.orderInReception > second.orderInReception)
            return NSOrderedDescending;

        return NSOrderedAscending;
    }];

    return [sortedArray mutableCopy];
}

- (void)onSearchOverlayTouch:(id)sender {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultSourahList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuranSourahInfo* info = [self.searchResultSourahList objectAtIndex:indexPath.row];
    QuranSourahListCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[QuranSourahListCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER];
    }

    [cell setModel:info];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuranSourahInfo* info = [self.searchResultSourahList objectAtIndex:indexPath.row];

    [self.quranPage setQuranPage:[[MuslimLib instance] getQuranSourahPage:info.orderInBook]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search Bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchOverlay.hidden = NO;
    self.searchOverlay.alpha = 0;

    [UIView animateWithDuration:0.3f animations:^{
        self.searchOverlay.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.searchOverlay.alpha = 0.4;
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.searchOverlay.alpha = 0.4;

    [UIView animateWithDuration:0.3f animations:^{
        self.searchOverlay.alpha = 0;
    } completion:^(BOOL finished) {
        self.searchOverlay.alpha = 0;
        self.searchOverlay.hidden = YES;
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchText = [[searchText stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    [self.searchResultSourahList removeAllObjects];

    if ([searchText isEqualToString:@""]) {
        for (int i = 0; i < self.sourahList.count; i++) {
            [self.searchResultSourahList addObject:[self.sourahList objectAtIndex:i]];
        }
    } else {
        for (int i = 0; i < self.sourahList.count; i++) {
            QuranSourahInfo* sourah = [self.sourahList objectAtIndex:i];

            if ([[sourah.titleArabic lowercaseString] contains:searchText] ||
                [[[sourah getTitleTranslation] lowercaseString] contains:searchText] ||
                [[sourah.titleEnglish lowercaseString] contains:searchText]) {

                [self.searchResultSourahList addObject:sourah];
            }
        }
    }

    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarTextDidEndEditing:searchBar];
}

@end
