//
//  SidebarViewController.m
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 8/13/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "SidebarViewController.h"
#import "SidebarItem.h"
#import "LanguageStrings.h"
#import "SidebarItemCell.h"
#import "Theme.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

static SidebarViewController* _instance;

+ (SidebarViewController*) instance {
    return _instance;
}

- (BOOL)hasSidebarButton {
    return NO;
}

- (void)viewDidLoad {
    _instance = self;
    [self setupSidebar];
    [super viewDidLoad];

    self.tblItems.dataSource = self;
    self.tblItems.delegate = self;
    self.tblItems.backgroundColor = [UIColor clearColor];
    self.tblItems.separatorColor = [UIColor clearColor];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tblItems reloadData];
}

- (void) setupSidebar {
    self.items = [[NSMutableArray alloc] init];

//    Sidebar/Quran:Holy Quran
//    Sidebar/ImamsPublications:Imams Books
//    Sidebar/HadithBooks:Hadiths Books
//    Sidebar/MafatihBook:Mafatih ol Janan
//    Sidebar/Settings:Settings
//    Sidebar/About:About


    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/MyAccount"] Segue:@"s_ShowAccount"]];
    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/Quran"] Segue:@"s_ShowQuran"]];
    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/ImamsPublications"] Segue:@"s_ShowCreatePage"]];
    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/HadithBooks"] Segue:@"s_ShowArchivePage"]];
    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/MafatihBook"] Segue:@"s_ShowSearchPage"]];
    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/Settings"] Segue:@"s_ShowSettingsPage"]];
    [self.items addObject:[[SidebarItem alloc] initWithTitle:[[LanguageStrings instance] get:@"Sidebar/About"] Segue:@"s_ShowAbout"]];

    self.cells = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.items.count; i++) {
        SidebarItemCell* cell = [[SidebarItemCell alloc] init];
        [cell setCellModel:[self.items objectAtIndex:i]];
        [self.cells addObject:cell];
    }
}

- (UIColor*)getBackgroundTopColor {
    return  [[Theme instance] defaultSidebarGradientTopColor];
}

- (UIColor*)getBackgroundBottomColor {
    return  [[Theme instance] defaultSidebarGradientBottomColor];
}


#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cells objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return [Utils isTablet] ? 205 : 150;
//    } else if ([Utils isIPhoneScreen35Inches]) {
//        return 55;
//    } else if ([Utils isTablet]) {
//        return 60;
//    }

    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SidebarItem* itemSelected = [self.items objectAtIndex:indexPath.row];
    NSString* segue = itemSelected.segue;

    [self performSegueWithIdentifier:segue sender:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
