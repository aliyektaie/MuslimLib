//
//  MainQuranViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/14/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "MainQuranViewController.h"
#import "Utils.h"
#import "LanguageStrings.h"
#import "Theme.h"
#import "QuranPagesIndexViewController.h"
#import "MuslimLib.h"
#import "QuranSourahIndexViewController.h"
#import "Settings.h"
#import "QuranVerseCell.h"
#import "ArabicLabel.h"

#define CELL_IDENTIFIER_VERSE @"cell_cerse_quran" 

@interface MainQuranViewController ()

@end

@implementation MainQuranViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bottomToolbar.tintColor = [Theme instance].navigationBarTintColor;
    self.quranPageViewer.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[QuranVerseCell class] forCellReuseIdentifier:CELL_IDENTIFIER_VERSE];

    self.title = L(@"Sidebar/Quran");

    self.cmdViews.title = L(@"QuranTab/ReadQuran/ViewsMode");

    [self.cmdViews setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [Utils createDefaultFont:16], NSFontAttributeName,
                                           nil]
                                 forState:UIControlStateNormal];

    self.mode = [Settings getLastViewedQuranMode];
    
    if (self.mode == MODE_BOOK) {
        [self setupBookMode];
    } else {
        [self setupReadingMode];
    }
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (void)setQuranPage:(int)page {
    self.page = page;

    if (self.mode == MODE_BOOK) {
        self.quranPageViewer.page = page;
        self.content = nil;
    } else if (self.mode == MODE_ARABIC_ONLY || self.mode == MODE_ARABIC_AND_TRANSLATION) {
        self.content = [self cloneContent:[[MuslimLib instance] getQuranVersesForPage:page]];
        for (int i = 0; i < self.content.count; i++) {
            QuranVerse* verse = [self.content objectAtIndex:i];
            verse.text = [verse.text stringByAppendingString:[NSString stringWithFormat:@" [%@] ", [Utils formatNumber:verse.verseNumber]]];
        }
    }


    self.pagePosition.title = [NSString stringWithFormat:@"﴾%@﴿", [Utils formatNumber:page]];
    self.currntSourah.title = [[MuslimLib instance] getQuranPageFirstSourahName:page];

    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

    if (self.saveCurrentPage) {
        [Settings setLastViewedQuranPage:page];
    }
    [Settings setLastViewedQuranMode:self.mode];
}

- (NSArray*)cloneContent:(NSArray*)array {
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:array.count];

    for (int i = 0; i < array.count; i++) {
        QuranVerse* verse = [array objectAtIndex:i];
        [result addObject:[verse cloneVerse]];
    }

    return result;
}


#pragma mark - Navigation

- (IBAction)onLastPage:(id)sender {
    [self setQuranPage:604];
}

- (IBAction)onNextPage:(id)sender {
    int page = self.page;
    page++;

    if (page <= 604) {
        [self setQuranPage:page];
    }
}

- (IBAction)onPreviousPage:(id)sender {
    int page = self.page;
    page--;

    if (page >= 1) {
        [self setQuranPage:page];
    }
}

- (IBAction)onFirstPage:(id)sender {
    [self setQuranPage:1];
}

- (IBAction)onPage:(id)sender {
//    QuranPagesIndexViewController* vc = [QuranPagesIndexViewController create];
//    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:vc];
//    [vc setParentViewController:self];
//
//    [self presentViewController:navController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"s_ShowQuranPagesIndex"]) {
        ((QuranPagesIndexViewController*)segue.destinationViewController).quranPage = self;
    } else if ([segue.identifier isEqualToString:@"s_ShowSourahList"]) {
        ((QuranSourahIndexViewController*)segue.destinationViewController).quranPage = self;
    }
}

- (IBAction)onSourah:(id)sender {
}

- (UIColor*)getBackgroundTopColor {
    return  [[Theme instance] lightPageGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return  [[Theme instance] lightPageGradientBottomColor];
}

- (IBAction)onSelectViewPressed:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:L(@"QuranTab/ReadQuran/ViewsModeTitle") message:L(@"QuranTab/ReadQuran/ViewsModeMessage") preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"QuranTab/ReadQuran/ViewModes/Page") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.mode = MODE_BOOK;
        [self setupBookMode];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"QuranTab/ReadQuran/ViewModes/QuranOnly") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.mode = MODE_ARABIC_ONLY;

        [self setupReadingMode];
//        [self.tableView reloadData];
    }]];


    [actionSheet addAction:[UIAlertAction actionWithTitle:L(@"QuranTab/ReadQuran/ViewModes/QuranAndTranslation") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.mode = MODE_ARABIC_AND_TRANSLATION;

        [self setupReadingMode];
//        [self.tableView reloadData];
    }]];

    actionSheet.popoverPresentationController.sourceView = self.actionSheetSource;
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)setupBookMode {
    self.quranPageViewer.hidden = NO;
    self.quranPageViewer.page = self.page;

    self.tableView.hidden = YES;
    [self setQuranPage:self.page];
}

- (void)setupReadingMode {
    self.quranPageViewer.hidden = YES;

    self.tableView.hidden = NO;
    [self setQuranPage:self.page];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuranVerseCell* cell = (QuranVerseCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_VERSE forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[QuranVerseCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER_VERSE];
    }

    QuranVerse* verse = [self.content objectAtIndex:indexPath.row];
    cell.verse = verse;
    cell.translations = [self getTranslations];
    cell.quranText.text = verse.text;

    return cell;
}

- (NSArray*)getTranslations {
    if (self.mode == MODE_ARABIC_ONLY) {
        return @[];
    }
    
    if (self.translations == nil) {
        NSMutableArray* result = [[NSMutableArray alloc] init];
        NSArray* tr = [[MuslimLib instance] getQuranAvailableTranslations];
        
        for (int i = 0; i < tr.count; i++) {
            QuranTranslationInfo* info = [tr objectAtIndex:i];
            if ([info isSelected]) {
                [result addObject:info];
            }
        }
        
        self.translations = result;
    }
    
    return self.translations;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.content == nil) {
        return 0;
    }

    return self.content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = 20;

    QuranVerse* verse = [self.content objectAtIndex:indexPath.row];
    result += [ArabicLabel getHeightForText:verse.text inWidth:CGRectGetWidth(self.tableView.frame) - 20];
    
    UILabel* titleLabel = [[UILabel alloc] init];

    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 100;

    
    NSArray* translations = [self getTranslations];
    for (int i = 0; i < translations.count; i++) {
        QuranTranslationInfo* info = [translations objectAtIndex:i];
        
        contentLabel.font = TRANSLATION_CONTENT_LABEL_FONT(info);
        titleLabel.font = TRANSLATION_TITLE_LABEL_FONT(info);
        
        titleLabel.text = info.title;
        contentLabel.text = [info getTranslation:verse];
        
        CGSize size = [titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.tableView.frame) - 20, 0)];
        result += size.height;
        
        size = [contentLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.tableView.frame) - 20, 0)];
        result += size.height;
        
        result += 10;
        result += 20;
    }

    return result;
}

@end
