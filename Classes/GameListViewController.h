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
  NSString* selectedKey;
}


@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UITableView *gameListTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;

@property (nonatomic, retain) NSMutableArray* gamesInProgressKeys;
@property (nonatomic, retain) NSMutableArray* gamesCompletedKeys;
@property (nonatomic, retain) NSMutableDictionary* gameList;
@property (nonatomic, retain) NSString *selectedKey;

- (IBAction) edit:(id)sender;

- (void) saveGame:(NSDictionary*)game forKey:(NSString*)key;
- (void) saveList;
- (void) setKeys;
- (id) valueForSection:(NSInteger)section valueInProgress:(id)valueInProgress valueCompleted:(id)valueCompleted;
- (NSString*) keyForIndexPath:(NSIndexPath*)index;
- (NSIndexPath*) indexPathForKey:(NSString*)key;

@end
