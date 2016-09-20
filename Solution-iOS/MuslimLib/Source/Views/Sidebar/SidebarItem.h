//
//  SidebarItem.h
//  MemoreX
//
//  Created by Mohammad Ali Yektaie on 7/23/15.
//  Copyright (c) 2015 Mohammad Ali Yektaie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SidebarItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* segue;

- (instancetype) initWithTitle: (NSString*)title Segue:(NSString*)segue;

@end
