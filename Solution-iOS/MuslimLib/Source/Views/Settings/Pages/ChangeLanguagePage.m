//
//  ChangeLanguagePage.m
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/10/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "ChangeLanguagePage.h"
#import "Theme.h"
#import "Settings.h"
#import "LightCollectionViewTileView.h"
#import "LanguageStrings.h"
#import "CollectionViewTile.h"
#import "Utils.h"

#define CELL_IDENTIFIER @"change_language_cell"

@implementation ChangeLanguagePage
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[LightCollectionViewTileView class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    self.title = [[LanguageStrings instance] get:@"ChangeLanguageWindow/Title"];
    self.lblRestartRequired.text = [[LanguageStrings instance] get:@"ChangeLanguageWindow/ConfirmLanguageChange"];
    self.lblRestartRequired.font = [Utils createDefaultFont:13];
    self.lblRestartRequired.textColor = [Theme instance].lightTextColor;
    
    [self createItems];
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (void)createItems {
    NSMutableArray* languages = [[NSMutableArray alloc] init];
    
    [languages addObject:[self createTile:@"English" withImage:@"English" withSegue:@"English"]];
    [languages addObject:[self createTile:@"فارسی" withImage:@"Persian" withSegue:@"Persian"]];
    
    
    self.tiles = languages;
}

- (CollectionViewTile*)createTile:(NSString*)title withImage:(NSString*)image withSegue:(NSString*)segue {
    CollectionViewTile* result = [[CollectionViewTile alloc] init];
    
    result.title = title;
    result.image = image;
    result.segueToPerform = segue;
    
    return result;
}

#pragma mark - Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LightCollectionViewTileView* cell = (LightCollectionViewTileView*)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    CollectionViewTile* tile = (CollectionViewTile*)[self.tiles objectAtIndex:indexPath.row];
    
    
    [cell setTitle:tile.title];
    [cell setImage:tile.image];
    cell.segueToPerform = tile.segueToPerform;
    cell.page = self;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils getSettingsTileSize];
}


- (UIColor*)getBackgroundTopColor {
    return [[Theme instance] lightPageGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return [[Theme instance] lightPageGradientBottomColor];
}

@end
