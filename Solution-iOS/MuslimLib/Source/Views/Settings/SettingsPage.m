//
//  SettingsPage.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/9/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "SettingsPage.h"
#import "Utils.h"
#import "CollectionViewTileView.h"
#import "CollectionViewTile.h"
#import "LanguageStrings.h"
#import "SettingsHeaderView.h"
#import "Theme.h"

#define CELL_IDENTIFIER @"settings_cell_id"

@implementation SettingsPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CollectionViewTileView class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self setupView];
}

- (void)setupView {
    self.sections = @[L(@"SettingsPage/Sections/General"),L(@"SettingsPage/Sections/Quran")];
    self.title = [[LanguageStrings instance] get:@"SettingsPage/Title"];
    [self createItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupView];
    [self.collectionView reloadData];
}

- (void)createItems {
    NSMutableArray* generalSettings = [[NSMutableArray alloc] init];

    [generalSettings addObject:[self createTile:L(@"SettingsPage/Settings/DefaultFont") withImage:@"SettingsDefaultFont" withSegue:@"s_ShowDefaultFont"]];
    [generalSettings addObject:[self createTile:L(@"SettingsPage/Settings/ChangeLanguage") withImage:@"SettingsChangeLanguage" withSegue:@"s_ShowChangeLanguage"]];

    NSMutableArray* quranSettings = [[NSMutableArray alloc] init];
    
    [quranSettings addObject:[self createTile:L(@"SettingsPage/Settings/Quran/Translations") withImage:@"SettingsQuranTranslations" withSegue:@"s_ShowQuranTranslations"]];
    [quranSettings addObject:[self createTile:L(@"SettingsPage/Settings/Quran/SpecialChars") withImage:@"SettingsHarekat" withSegue:@"s_ShowQuranSpecialChars"]];
    
    self.tiles = @[generalSettings, quranSettings];
}

- (CollectionViewTile*)createTile:(NSString*)title withImage:(NSString*)image withSegue:(NSString*)segue {
    CollectionViewTile* result = [[CollectionViewTile alloc] init];
    
    result.title = title;
    result.image = image;
    result.segueToPerform = segue;
    
    return result;
}

#pragma mark - Collection View
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        SettingsHeaderView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SETTING_HEADER" forIndexPath:indexPath];
        NSString *title = (NSString*)[self.sections objectAtIndex:indexPath.section];
        headerView.titleView.text = title;
        headerView.titleView.font = [Utils createDefaultBoldFont:15];
        headerView.titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray*)[self.tiles objectAtIndex:section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewTileView* cell = (CollectionViewTileView*)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSArray* sec = (NSArray*)[self.tiles objectAtIndex:indexPath.section];
    CollectionViewTile* tile = (CollectionViewTile*)[sec objectAtIndex:indexPath.row];
    
    
    [cell setTitle:tile.title];
    [cell setImage:tile.image];
    cell.page = self;
    cell.segueToPerform = tile.segueToPerform;
    
    return cell;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.tiles.count;
}    

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils getSettingsTileSize];
}

- (BOOL)hasSidebarButton {
    return NO;
}

@end
