//
//  BaseViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIBarButtonItem *leftSidebarButton;
@property (strong, nonatomic) UIBarButtonItem *rightSidebarButton;
@property (strong, nonatomic) CAGradientLayer* layer;
@property (assign, nonatomic) BOOL backgroundLayerAdded;
@property (assign, nonatomic) BOOL shouldSetBackground;
@property (assign, nonatomic) BOOL isKeyboardShown;
@property (strong, nonatomic) UIView* keyboardOverlay;

- (UIColor*)getBackgroundTopColor;
- (UIColor*)getBackgroundBottomColor;

- (BOOL)handleKeyboardEvent;
- (NSArray*)getViewsThatTriggerKeyboard;


- (BOOL)hasSidebarButton;

@end
