//
//  QuranSourahOptionsAndDetailsViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranSourahOptionsAndDetailsViewController.h"
#import "Utils.h"
#import "LanguageStrings.h"
#import "ValuePair.h"
#import "TableViewLinkCell.h"
#import "TableViewInfoCell.h"
#import "QuranSourahSummaryViewController.h"

#define STR(x) [NSString stringWithFormat:@"%d", x]

#define BOOK_ORDER @"QuranTab/SourahList/Details/Positions/BookOrder"
#define CHRONOLOGICAL_ORDER @"QuranTab/SourahList/Details/Positions/ChronologicalOrder"

#define OPTIONS_SHOW_QURAN @"QuranTab/SourahList/Details/Options/ShowQuran"
#define OPTIONS_SHOW_COMMENTARY @"QuranTab/SourahList/Details/Options/ShowCommentary"
#define OPTIONS_SHOW_MORE @"QuranTab/SourahList/Details/Options/ShowArticle"


#define SECTION_POSITIONS 2
#define SECTION_DETAILS 1
#define SECTION_OPTIONS 0

#define CELL_IDENTIFIER_POSITIONS @"cell_for_positions"
#define CELL_IDENTIFIER_OPTIONS @"cell_for_options"
#define CELL_IDENTIFIER_DETAILS @"cell_for_details"

@interface QuranSourahOptionsAndDetailsViewController () {
    NSMutableArray* positions;
    NSMutableArray* options;
    NSMutableArray* details;
}

@end

@implementation QuranSourahOptionsAndDetailsViewController

+ (QuranSourahOptionsAndDetailsViewController*)create:(QuranSourahInfo*)model {
    QuranSourahOptionsAndDetailsViewController* vc = (QuranSourahOptionsAndDetailsViewController*)[Utils createViewControllerFromStoryboard:@"QuranSourahOptionsAndDetailsViewController"];

    vc.sourahInfo = model;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* title = L(@"QuranTab/SourahList/Details/Title");
    title = [title stringByReplacingOccurrencesOfString:@"$englishName" withString:self.sourahInfo.titleEnglish];
    title = [title stringByReplacingOccurrencesOfString:@"$arabicName" withString:self.sourahInfo.titleArabic];
    self.title = title;

    [self loadPositions];
    [self loadOptions];
    [self loadDetails];

    [self.tableView registerClass:[TableViewInfoCell class] forCellReuseIdentifier:CELL_IDENTIFIER_POSITIONS];
    [self.tableView registerClass:[TableViewLinkCell class] forCellReuseIdentifier:CELL_IDENTIFIER_OPTIONS];
    [self.tableView registerClass:[TableViewInfoCell class] forCellReuseIdentifier:CELL_IDENTIFIER_DETAILS];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.automaticallyAdjustsScrollViewInsets = false;
}

#pragma mark - Loading Content
- (void)loadPositions {
    positions = [[NSMutableArray alloc] init];

    [positions addObject:VALUE_PAIR(BOOK_ORDER, [Utils formatNumber:self.sourahInfo.orderInBook])];
    [positions addObject:VALUE_PAIR(CHRONOLOGICAL_ORDER, [Utils formatNumber:self.sourahInfo.orderInReception])];
}

- (void)loadOptions {
    options = [[NSMutableArray alloc] init];

    [options addObject:VALUE_PAIR(OPTIONS_SHOW_QURAN, @"")];
    [options addObject:VALUE_PAIR(OPTIONS_SHOW_COMMENTARY, @"")];
    [options addObject:VALUE_PAIR(OPTIONS_SHOW_MORE, @"")];
}

- (void)loadDetails {
    details = [[NSMutableArray alloc] init];

    [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/Classification", [self.sourahInfo getClassification])];
    if ([[LanguageStrings instance] getBoolean:@"QuranTab/SourahList/Details/Details/HasTitleTranslation"]) {
        [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/TitleTranslation", [self.sourahInfo getTitleTranslation])];
    }
    [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/TitleRefersTo", [self.sourahInfo getTitleReference])];
    if ([self.sourahInfo hasContentConcepts]) {
        [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/ContentConcepts", [self.sourahInfo getContentConcepts])];
    }

    [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/VerseCount", [Utils formatNumber:self.sourahInfo.verseCount])];

    if (self.sourahInfo.wordCount > 0) {
        [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/WordCount", [Utils formatNumber:self.sourahInfo.wordCount])];
    }

    if (self.sourahInfo.letterCount > 0) {
        [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/LetterCount", [Utils formatNumber:self.sourahInfo.letterCount])];
    }
    
    [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/NumberOfSajdah", [Utils formatNumber:self.sourahInfo.sijdahCount])];

    if ([self.sourahInfo hasMoghataat]) {
        NSString* moghataat = L(@"QuranTab/SourahList/Details/Details/MoghataaLettersFormat");
        moghataat = [moghataat stringByReplacingOccurrencesOfString:@"$englishLetters" withString:self.sourahInfo.moghataatEnglish];
        moghataat = [moghataat stringByReplacingOccurrencesOfString:@"$arabicLetters" withString:self.sourahInfo.moghataatArabic];

        [details addObject:VALUE_PAIR(@"QuranTab/SourahList/Details/Details/MoghataaLetters", moghataat)];
    }

//    QuranTab/SourahList/Details/Details/WordCount:Word Count
//    QuranTab/SourahList/Details/Details/LetterCount:Letter Count
//    QuranTab/SourahList/Details/Details/MoghataaLetters:Opening muqaṭṭaʻāt
//    QuranTab/SourahList/Details/Details/HizbNumber:Hizb Number
//    QuranTab/SourahList/Details/Details/NumberOfSajdah:Number of Sajdah
//    QuranTab/SourahList/Details/Details/OtherNames:Other Names
//    QuranTab/SourahList/Details/Details/OtherNamesArabic:Other Names in Arabic

}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SECTION_POSITIONS) {
        return positions.count;
    } else if (section == SECTION_OPTIONS) {
        return options.count;
    } else if (section == SECTION_DETAILS) {
        return details.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* result = nil;

    if (indexPath.section == SECTION_POSITIONS) {
        TableViewInfoCell* cell = (TableViewInfoCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_POSITIONS forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TableViewInfoCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER_POSITIONS];
        }

        cell.model = [positions objectAtIndex:indexPath.row];
        result = cell;
    } else if (indexPath.section == SECTION_OPTIONS) {
        TableViewLinkCell* cell = (TableViewLinkCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_OPTIONS forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TableViewLinkCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER_OPTIONS];
        }

        ValuePair* valuePair = [options objectAtIndex:indexPath.row];
        [cell setLinkText:L(valuePair.title)];
        result = cell;
    } else if (indexPath.section == SECTION_DETAILS) {
        TableViewInfoCell* cell = (TableViewInfoCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_DETAILS forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TableViewInfoCell alloc] initWithReuseIdentifier:CELL_IDENTIFIER_DETAILS];
        }

        cell.model = [details objectAtIndex:indexPath.row];
        result = cell;
    }

    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* result = nil;

    if (section == SECTION_POSITIONS) {
        result = L(@"QuranTab/SourahList/Details/HeaderPosition");
    } else if (section == SECTION_DETAILS) {
        result = L(@"QuranTab/SourahList/Details/HeaderDetails");
    } else if (section == SECTION_OPTIONS) {
        result = L(@"QuranTab/SourahList/Details/HeaderOptions");
    }

    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_DETAILS) {
        ValuePair* value = [details objectAtIndex:indexPath.row];
        return [[[TableViewInfoCell alloc] init] getHeight:value];
    } else if (indexPath.section == SECTION_POSITIONS) {
        ValuePair* value = [positions objectAtIndex:indexPath.row];
        return [[[TableViewInfoCell alloc] init] getHeight:value];
    }

    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_OPTIONS) {
        ValuePair* value = [options objectAtIndex:indexPath.row];
        if ([value.title isEqualToString:OPTIONS_SHOW_MORE]) {
            [self showSourahArticle];
        } else if ([value.title isEqualToString:OPTIONS_SHOW_QURAN]) {
            [self showSourahInQuran];
        } else if ([value.title isEqualToString:OPTIONS_SHOW_COMMENTARY]) {
            [self showSourahCommentary];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TableView Link Handlers

- (void)showSourahArticle {
    QuranSourahSummaryViewController* vc = [QuranSourahSummaryViewController create:self.sourahInfo];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSourahInQuran {

}

- (void)showSourahCommentary {

}

@end
