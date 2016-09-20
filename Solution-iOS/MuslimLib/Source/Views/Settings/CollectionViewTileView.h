//
//  CollectionViewTileView.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 8/9/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewTileView : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIButton* titleText;
@property (strong, nonatomic) UIButton* icon;
@property (strong, nonatomic) NSString* segueToPerform;
@property (strong, nonatomic) UIViewController* page;

@property (assign, nonatomic) BOOL shouldFillImage;

- (void)initialize:(NSString*)text;

- (void)setTitle:(NSString*)title;
- (void)setImage:(NSString*)image;

@end
