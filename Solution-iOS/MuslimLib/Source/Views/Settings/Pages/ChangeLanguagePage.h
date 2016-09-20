//
//  ChangeLanguagePage.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/10/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeLanguagePage : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray* tiles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblRestartRequired;

@end
