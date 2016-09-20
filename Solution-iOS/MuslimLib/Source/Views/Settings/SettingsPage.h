//
//  SettingsPage.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/9/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface SettingsPage : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray* tiles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray* sections;

@end
