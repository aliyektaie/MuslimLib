//
//  QuranHomePage.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/20/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "QuranHomePage.h"
#import "CollectionViewTileView.h"
#import "LanguageStrings.h"
#import "CollectionViewTile.h"
#import "SettingsHeaderView.h"
#import "Utils.h"
#import "Theme.h"
#import "Settings.h"
#import "MainQuranViewController.h"
#import "Settings.h"

#define CELL_IDENTIFIER @"quran_home_cell_id"

@implementation QuranHomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CollectionViewTileView class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self setupView];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = [self getSettingsTileSize];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
}

- (void)setupView {
    self.sections = @[L(@"QuranHomePage/Sections/Read")];
    self.title = [[LanguageStrings instance] get:@"Sidebar/Quran"];
    [self createItems];
}


- (BOOL)hasSidebarButton {
    return NO;
}

- (void)createItems {
    NSMutableArray* readSection = [[NSMutableArray alloc] init];
    
    
    NSString* readTitle = L(@"QuranHomePage/Sections/ReadKhatmContinue");
    if ([Settings getLastViewedQuranPage] == 1) {
        readTitle = L(@"QuranHomePage/Sections/ReadKhatmStart");
    }
    
    [readSection addObject:[self createTile:readTitle withImage:@"ReadQuran" withSegue:@"s_ShowReadingQuran"]];
    [readSection addObject:[self createTile:L(@"QuranHomePage/Sections/ReadRandomPage") withImage:@"ReadQuranRandom" withSegue:@"s_ShowReadingQuranRandom"]];
    
    self.tiles = @[readSection];
}

- (CollectionViewTile*)createTile:(NSString*)title withImage:(NSString*)image withSegue:(NSString*)segue {
    CollectionViewTile* result = [[CollectionViewTile alloc] init];
    
    result.title = title;
    result.image = image;
    result.segueToPerform = segue;
    result.isImageCoveringAllBackground = YES;
    
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
    
    cell.shouldFillImage = YES;
    
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
    return [self getSettingsTileSize];
}

- (CGSize)getSettingsTileSize {
    if ([Utils isTablet]) {
        return CGSizeMake (240, 240);
    }
    
    int width = (int)(([UIScreen mainScreen].bounds.size.width) / 2);
    return CGSizeMake (width, width);
}

- (UIColor*)getBackgroundTopColor {
    return  [Theme instance].lightPageGradientTopColor;
}

- (UIColor*)getBackgroundBottomColor {
    return  [Theme instance].lightPageGradientBottomColor;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"s_ShowReadingQuran"]) {
        MainQuranViewController* controller = (MainQuranViewController*)segue.destinationViewController;
        controller.page = [Settings getLastViewedQuranPage];
        controller.saveCurrentPage = YES;
    } else if ([segue.identifier isEqualToString:@"s_ShowReadingQuranRandom"]) {
        MainQuranViewController* controller = (MainQuranViewController*)segue.destinationViewController;
        
        int lowerBound = 1;
        int upperBound = 604;
        int page = lowerBound + arc4random() % (upperBound - lowerBound);
        
        page = 604;
        
        controller.page = page;
        controller.saveCurrentPage = NO;
    }
}

@end
