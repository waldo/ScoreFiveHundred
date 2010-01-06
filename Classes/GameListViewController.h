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
  IBOutlet UIBarButtonItem *editButton;

  NSMutableArray* gamesInProgressKeys;
  NSMutableArray* gamesCompletedKeys;
  NSMutableDictionary* gameList;
}


@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UITableView *gameListTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;

@property (nonatomic, retain) NSMutableArray* gamesInProgressKeys;
@property (nonatomic, retain) NSMutableArray* gamesCompletedKeys;
@property (nonatomic, retain) NSMutableDictionary* gameList;

- (IBAction) edit:(id)sender;

- (void) saveGame:(NSDictionary*)game ForKey:(NSString*)key;
- (void) saveList;
- (void) setKeys;
- (id) valueForSection:(NSInteger)section ValueInProgress:(id)valueInProgress ValueCompleted:(id)valueCompleted;

@end
