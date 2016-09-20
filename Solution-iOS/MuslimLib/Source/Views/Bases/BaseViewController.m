//
//  BaseViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/9/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "LanguageStrings.h"
#import "Theme.h"
#import "SWRevealViewController.h"
#import "SidebarParameters.h"

@interface BaseViewController () {
    BOOL alreadyAddedGuestures;
}


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self hasSidebarButton]) {
        [self setupNavigationBar];

        if ([[LanguageStrings instance] isRightToLeft]) {
            [self initializeSidebar:self.rightSidebarButton];
            self.rightSidebarButton.tintColor = [Theme instance].navigationBarTintColor;
            self.leftSidebarButton.tintColor = [UIColor clearColor];
        } else {
            [self initializeSidebar:self.leftSidebarButton];
            self.leftSidebarButton.tintColor = [Theme instance].navigationBarTintColor;
            self.rightSidebarButton.tintColor = [UIColor clearColor];
        }
    }

    [self setupKeyboardHandle];

    self.shouldSetBackground = YES;
}

- (BOOL)hasSidebarButton {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self removeBackground];
    [self setGradientBackground];
}

#pragma mark - Theme
- (UIColor*)getBackgroundTopColor {
    return  [[Theme instance] defaultPageGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return  [[Theme instance] defaultPageGradientBottomColor];
}


#pragma mark - Background
- (void)removeBackground {
    if (self.shouldSetBackground) {
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        self.backgroundLayerAdded = NO;
    }
}

- (void)setGradientBackground {
    if (self.shouldSetBackground) {
        if (self.layer == nil) {
            [self initializeBackgroundLayer];
        }

        [self setGradientLayerFrame];

        if (!self.backgroundLayerAdded) {
            [self.view.layer insertSublayer:self.layer atIndex:0];
            self.backgroundLayerAdded = YES;
        }
    }
}

- (void) initializeBackgroundLayer
{
    UIColor* colorTop = [self getBackgroundTopColor];
    UIColor* colorBottom = [self getBackgroundBottomColor ];
    self.layer = [[CAGradientLayer alloc] init];

    self.layer.colors = @[(id)[colorTop CGColor], (id)[colorBottom CGColor] ];
    self.layer.locations = @[[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1]];
}


#pragma mark - Layout
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self setGradientLayerFrame];
}

-(void)setGradientLayerFrame{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    self.layer.frame = CGRectMake(0, 0, width, height);
}

- (void)setupNavigationBar {
    self.rightSidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SidebarImage"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(rightRevealToggle:)];
    self.leftSidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SidebarImage"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];

    self.navigationItem.rightBarButtonItem = self.rightSidebarButton;
    self.navigationItem.leftBarButtonItem = self.leftSidebarButton;
}

- (void) initializeSidebar:(UIBarButtonItem*)sidebarButton {
    sidebarButton.tintColor = [Theme instance].navigationBarTintColor;

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [sidebarButton setTarget: self.revealViewController];

        if ([SidebarParameters isRightToLeft]) {
            [sidebarButton setAction: @selector( rightRevealToggle: )];
        } else {
            [sidebarButton setAction: @selector( revealToggle: )];
        }

        if (!alreadyAddedGuestures) {
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

            alreadyAddedGuestures = YES;
        }
    }
}

#pragma mark - Keyboard
- (BOOL)handleKeyboardEvent {
    return NO;
}

- (NSArray*)getViewsThatTriggerKeyboard {
    return [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)setupKeyboardHandle {
    if ([self handleKeyboardEvent]) {
        UITapGestureRecognizer* tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped)];
        [tapGuesture setNumberOfTapsRequired:1];

        self.view.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:tapGuesture];
    }
}

- (void)onViewTapped {
    NSArray* views = [self getViewsThatTriggerKeyboard];

    for (int i = 0; i < views.count; i++) {
        UIView* view = (UIView*)[views objectAtIndex:i];
        [view resignFirstResponder];
    }
}

@end
