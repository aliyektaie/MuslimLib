//
//  QuranHomePage.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 9/20/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface QuranHomePage : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray* tiles;
@property (strong, nonatomic) NSArray* sections;


@end
