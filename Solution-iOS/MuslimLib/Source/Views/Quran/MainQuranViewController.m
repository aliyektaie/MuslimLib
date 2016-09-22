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
#import <STPopup/STPopup.h>
#import "QuranViewOptionsViewController.h"
#import "QuranVerseOptionsViewController.h"

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

- (void)updateTranslationChange {
    self.translations = nil;
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
    QuranViewOptionsViewController* controller = (QuranViewOptionsViewController*)[Utils createViewControllerFromStoryboard:@"QuranViewOptionsViewController"];
    controller.contentSizeInPopup = CGSizeMake(300, 400);
    controller.parentPage = self;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:controller];
    [popupController presentInViewController:self];
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

    if ([self isSourahTitleRow:(int)indexPath.row]) {
        int besmCountBefore = [self getSourahHeaderBeforeRow:(int)indexPath.row + 1];
        QuranVerse* verse = [self.content objectAtIndex:indexPath.row - besmCountBefore + 1];

        cell.besmAllahSourahInfo = verse.sourahInfo;
        cell.isBesmAllah = YES;
    } else {
        cell.isBesmAllah = NO;
        int besmCountBefore = [self getSourahHeaderBeforeRow:(int)indexPath.row];
        QuranVerse* verse = [self.content objectAtIndex:indexPath.row - besmCountBefore];
        cell.verse = verse;
        cell.translations = [self getTranslations];
        cell.quranText.text = verse.text;
    }

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
    
    int numberOfSourahHeader = 0;
    for (int i = 0; i < self.content.count; i++) {
        QuranVerse* verse = [self.content objectAtIndex:i];
        if (verse.verseNumber == 1) {
            numberOfSourahHeader++;
        }
    }

    return self.content.count + numberOfSourahHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = 20;
    
    if ([self isSourahTitleRow:(int)indexPath.row]) {
        int besmCountBefore = [self getSourahHeaderBeforeRow:(int)indexPath.row + 1];
        QuranVerse* verse = [self.content objectAtIndex:indexPath.row - besmCountBefore + 1];

        return [QuranVerseCell getBesmAllahCellHeight:CGRectGetWidth(tableView.frame) sourahInfo:verse.sourahInfo];
    }

    int besmCountBefore = [self getSourahHeaderBeforeRow:(int)indexPath.row];
    QuranVerse* verse = [self.content objectAtIndex:indexPath.row - besmCountBefore];
    result += [ArabicLabel getHeightForText:verse.text inWidth:CGRectGetWidth(self.tableView.frame) - 20];
    
    UILabel* titleLabel = [[UILabel alloc] init];

    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 100;

    
    NSArray* translations = [self getTranslations];
    if (translations.count == 1) {
        QuranTranslationInfo* info = [translations objectAtIndex:0];
        
        contentLabel.font = TRANSLATION_CONTENT_LABEL_FONT(info);
        contentLabel.text = [info getTranslation:verse];
        
        CGSize size = [contentLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.tableView.frame) - 20, 0)];
        result += size.height;
        
        result += 20;
    } else {
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
    }

    return result;
}

- (BOOL)isSourahTitleRow:(int)rowIndex {
    int currentCount = rowIndex - [self getSourahHeaderBeforeRow:rowIndex];
    if (currentCount + 1 >= self.content.count) {
        return NO;
    }
    
    int nextCount = rowIndex - [self getSourahHeaderBeforeRow:rowIndex + 1];
    
    return nextCount != currentCount;
}

- (int)getSourahHeaderBeforeRow:(int)rowIndex {
    int result = 0;
    
    int index = 0;
    for (int i = 0; i < rowIndex; i++) {
        QuranVerse* verse = [self.content objectAtIndex:index];
        if (verse.verseNumber == 1) {
            result++;
            i++;
        }
        
        index++;
    }
    
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self isSourahTitleRow:(int)indexPath.row]) {
        int besmCountBefore = [self getSourahHeaderBeforeRow:(int)indexPath.row];
        QuranVerse* verse = [self.content objectAtIndex:indexPath.row - besmCountBefore];
        
        [self showVerseOptions:verse];
    }
}

- (void)showVerseOptions:(QuranVerse*)verse {
    QuranVerseOptionsViewController* controller = (QuranVerseOptionsViewController*)[Utils createViewControllerFromStoryboard:@"QuranVerseOptionsViewController"];
    controller.contentSizeInPopup = CGSizeMake(300, 400);
    controller.verse = verse;
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:controller];
    [popupController presentInViewController:self];   
}

@end
