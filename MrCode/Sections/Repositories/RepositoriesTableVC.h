//
//  RepositoriesTableVC.h
//  MrCode
//
//  Created by hao on 7/4/15.
//  Copyright (c) 2015 hao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RepositoriesTableVCReposType) {
    RepositoriesTableVCReposTypePublic = 0,
    RepositoriesTableVCReposTypeStarred = 1,
    RepositoriesTableVCReposTypeForked = 2
};

@interface RepositoriesTableVC : UITableViewController

@property (nonatomic, copy) NSString *user;
@property (nonatomic, assign) RepositoriesTableVCReposType reposType;

@end
