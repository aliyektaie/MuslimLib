//
//  ModuleDownloaderPageViewController.h
//  MuslimLib
//
//  Created by Mohammad Ali Yektaie on 10/12/16.
//  Copyright © 2016 YekiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "ModuleDownloaderPageViewController.h"

typedef void (^ MODULE_DOWNLOADED_ACTION)();

@interface ModuleDownloaderPageViewController : BaseViewController

+ (ModuleDownloaderPageViewController*)create:(NSString*)module;

@property (strong, nonatomic) NSString* module;

- (void)setModuleDownloadedAction:(MODULE_DOWNLOADED_ACTION)action;
- (void)setModuleDownloadFailureAction:(MODULE_DOWNLOADED_ACTION)action;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cmdCancel;
@property (weak, nonatomic) IBOutlet UITextView *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *cmdDownload;

@end
