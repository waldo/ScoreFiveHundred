//
//  GameListViewController.m
//  ScoreFiveHundred
//
//  Created by Ben Walsham on 02/01/2010.
//  Copyright 2010 MeltingWaldo. All rights reserved.
//

#import "GameListViewController.h"
#import "ScoreFiveHundredAppDelegate.h"

@implementation NSDictionary (gameComparison)

- (NSComparisonResult) compareGameByLastPlayed:(NSDictionary*)game {
  return [[game objectForKey:@"last played"] compare:[self objectForKey:@"last played"]];
}

@end


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

static NSString* ssTitleInProgress    = @"In Progress";
static NSString* ssTitleCompleted     = @"Complete";

// MARK: synthesize
@synthesize cellWrapper;
@synthesize gameListTableView;
@synthesize editButton;

@synthesize gamesInProgressKeys;
@synthesize gamesCompletedKeys;
@synthesize gameList;
@synthesize selectedKey;


- (void)dealloc {
  [cellWrapper dealloc];
  [gameListTableView dealloc];
  [editButton dealloc];
  
  [gamesInProgressKeys dealloc];
  [gamesCompletedKeys dealloc];
  [gameList dealloc];
  
  [super dealloc];
}

- (IBAction) edit:(id)sender {
  [self setEditing:!self.editing animated:YES];
}

- (void) saveGame:(NSDictionary *)game forKey:(NSString *)key {
  self.selectedKey = key;

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
  
  [self setKeys];
  [self.gameListTableView reloadData];  
}

- (void) setKeys {
  NSMutableArray* inProgress = [[[NSMutableArray alloc] init] autorelease];
  NSMutableArray* completed = [[[NSMutableArray alloc] init] autorelease];
  NSDictionary* game = nil;
  
  for (NSString* key in [self.gameList keysSortedByValueUsingSelector:@selector(compareGameByLastPlayed:)]) {
    game = [self.gameList objectForKey:key];
    if ([game objectForKey:ssStoreWinningSlot] == nil) {
      [inProgress addObject:key];
    }
    else {
      [completed addObject:key];
    }
  }
  
  self.gamesInProgressKeys = inProgress;
  self.gamesCompletedKeys = completed;
}

- (NSString*) keyForIndexPath:(NSIndexPath*)index {
  return [[self valueForSection:index.section valueInProgress:self.gamesInProgressKeys valueCompleted:self.gamesCompletedKeys] objectAtIndex:index.row];
}

- (NSIndexPath*) indexPathForKey:(NSString*)key {
  NSIndexPath* index = nil;
  
  if ([self.gamesInProgressKeys indexOfObject:key] != NSNotFound) {
    index = [NSIndexPath indexPathForRow:[self.gamesInProgressKeys indexOfObject:key] inSection:[[self valueForSection:0 valueInProgress:[NSNumber numberWithInt:0] valueCompleted:[NSNumber numberWithInt:1]] intValue]];
  }
  else if ([self.gamesCompletedKeys indexOfObject:key] != NSNotFound) {
    index = [NSIndexPath indexPathForRow:[self.gamesCompletedKeys indexOfObject:key] inSection:[[self valueForSection:1 valueInProgress:[NSNumber numberWithInt:0] valueCompleted:[NSNumber numberWithInt:1]] intValue]];    
  }
  
  return index;
}

- (id) valueForSection:(NSInteger)section valueInProgress:(id)valueInProgress valueCompleted:(id)valueCompleted {
  id val = nil;
  
  if ([self.gamesInProgressKeys count] == 0 && [self.gamesCompletedKeys count] > 0) {
    val = valueCompleted;
  }
  else {
    if (section == 0) {
      val = valueInProgress;
    }
    else {
      val = valueCompleted;
    }
  }  
  
  return val;
}
    
// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];
  
  NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
  self.gameList = [NSMutableDictionary dictionaryWithDictionary:[store dictionaryForKey:ssStoreGames]];

  [self setKeys];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.gameListTableView reloadData];
  if (self.selectedKey != nil) {
    [self.gameListTableView selectRowAtIndexPath:[self indexPathForKey:selectedKey] animated:NO scrollPosition:UITableViewScrollPositionNone];
  }
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.selectedKey != nil) {
    [self.gameListTableView deselectRowAtIndexPath:[self indexPathForKey:selectedKey] animated:YES];
    
     self.selectedKey = nil;
  }
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

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
  int sections = 0;
  
  if ([self.gamesInProgressKeys count] > 0) {
    sections++;
  }
  if ([self.gamesCompletedKeys count] > 0) {
    sections++;
  }
  
	return sections;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return [self valueForSection:section valueInProgress:ssTitleInProgress valueCompleted:ssTitleCompleted];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self valueForSection:section valueInProgress:[NSNumber numberWithInteger:[self.gamesInProgressKeys count]] valueCompleted:[NSNumber numberWithInteger:[self.gamesCompletedKeys count]]] integerValue];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CellGame";
  
  CellGame *cellGame = (CellGame *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellGame == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellGame = (CellGame *)self.cellWrapper.cell;
  }

  NSDictionary *game = [self.gameList valueForKey:[self keyForIndexPath:indexPath]];
  
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self setEditing:NO animated:NO];
  
  self.selectedKey = [self keyForIndexPath:indexPath];
  
  ScoreFiveHundredAppDelegate* app = (ScoreFiveHundredAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  [app viewGame:[self.gameList objectForKey:self.selectedKey] WithKey:self.selectedKey AndIsNewGame:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.gameList removeObjectForKey:[self keyForIndexPath:indexPath]];

    [self saveList];
  }
}


@end