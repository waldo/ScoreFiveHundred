//
//  GameListViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import "GameListViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation GameListViewController

// MARK: static
static NSString *ssStoreGames         = @"five hundred games";
static NSString *ssStoreRounds        = @"rounds";
static NSString *ssStoreNameTeamOne   = @"team one name";
static NSString *ssStoreNameTeamTwo   = @"team two name";
static NSString *ssStoreScoreTeamOne  = @"team one score";
static NSString *ssStoreScoreTeamTwo  = @"team two score";
static NSString *ssStoreWinningSlot   = @"winning slot";
static NSString *ssStoreLastPlayed    = @"last played";

// MARK: synthesize
@synthesize cellWrapper;
@synthesize gameListTableView;
@synthesize editButton;

@synthesize gameKeys;
@synthesize gameList;

- (void)dealloc {
  [gameListTableView dealloc];
  [cellWrapper dealloc];
  
  [super dealloc];
}

- (IBAction) edit:(id)sender {
  [self setEditing:!self.editing animated:YES];
}

- (void) saveGame:(NSDictionary *)game ForKey:(NSString *)key {
  if (
      [[game objectForKey:ssStoreRounds] count]       == 0 && 
      [[game objectForKey:ssStoreNameTeamOne] length] == 0 && 
      [[game objectForKey:ssStoreNameTeamTwo] length] == 0
      ) {
    [self.gameList removeObjectForKey:key];
  }
  else {
    [self.gameList setObject:game forKey:key];
  }

  [self saveList];
}

- (void) saveList {
  NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
  
  [store setObject:self.gameList forKey:ssStoreGames];
  
  self.gameKeys = [NSMutableArray arrayWithArray:[self.gameList allKeys]];    
  [self.gameListTableView reloadData];  
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];
  
  NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
  self.gameList = [NSMutableDictionary dictionaryWithDictionary:[store dictionaryForKey:ssStoreGames]];
  self.gameKeys = [NSMutableArray arrayWithArray:[self.gameList allKeys]];    
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.gameListTableView reloadData];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  
  [self.gameListTableView setEditing:editing animated:animated];
    
  if (self.editing) {
    self.editButton.title = @"Done";
  }
  else {
    self.editButton.title = @"Edit";
  }
}

// MARK: TableView delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString* key = [self.gameKeys objectAtIndex:indexPath.row];

  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  [app viewGame:[self.gameList objectForKey:key] WithKey:key AndIsNewGame:NO];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.gameKeys count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellGame";
  
  CellGame *cellGame = (CellGame *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellGame == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellGame = (CellGame *)self.cellWrapper.cell;
  }
  
  NSDictionary *game = [self.gameList valueForKey:[self.gameKeys objectAtIndex:indexPath.row]];
  
  cellGame.nameTeamOne.text = [game valueForKey:ssStoreNameTeamOne];
  cellGame.nameTeamTwo.text = [game valueForKey:ssStoreNameTeamTwo];
  cellGame.pointsTeamOne.text = [[game valueForKey:ssStoreScoreTeamOne] stringValue];
  cellGame.pointsTeamTwo.text = [[game valueForKey:ssStoreScoreTeamTwo] stringValue];
  
  // show icon for winning team
  NSNumber* winningSlot = [game valueForKey:ssStoreWinningSlot];
  if (winningSlot == nil) {
    cellGame.symbolResultTeamOne.hidden = YES;
    cellGame.symbolResultTeamTwo.hidden = YES;
  }
  else if (0 == [winningSlot intValue]) {
    cellGame.symbolResultTeamOne.hidden = NO;
  }
  else if (1 == [winningSlot intValue]) {
    cellGame.symbolResultTeamTwo.hidden = NO;
  }
  
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  
  cellGame.dateLastPlayed.text = [formatter stringFromDate:[game valueForKey:ssStoreLastPlayed]];

  [formatter release];
  
  return cellGame;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.gameList removeObjectForKey:[self.gameKeys objectAtIndex:indexPath.row]];

    [self saveList];
  }
}



@end
