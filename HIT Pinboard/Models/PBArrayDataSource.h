//
//  PBFeatureListDataSource.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/9/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 A great practice of http://www.objc.io/issue-1/lighter-view-controllers.html
 */

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface PBArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
