//
//  GameListViewController.h
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreFiveHundredAppDelegate;
#import "CellWrapper.h"
#import "CellGame.h"


@interface GameListViewController : UIViewController {
  IBOutlet CellWrapper *cellWrapper;
  IBOutlet UITableView *gameListTableView;

  NSMutableArray* gameKeys;
  NSMutableDictionary* gameList;
}

@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UITableView *gameListTableView;

@property (nonatomic, retain) NSMutableArray* gameKeys;
@property (nonatomic, retain) NSMutableDictionary* gameList;

- (void) saveGame:(NSDictionary*)game ForKey:(NSString*)key;

@end