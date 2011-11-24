#import "GameListViewController.h"
#import "Game.h"
#import "Setting.h"

@implementation GameListViewController

// MARK: static
static NSString* ssTitleInProgress    = @"In Progress";
static NSString* ssTitleCompleted     = @"Complete";

// MARK: synthesize
@synthesize cellWrapper,
            gameListTableView,
            navItem,
            addButton,
            setUpController,
            gameController,
            managedObjectContext,
            gamesInProgress,
            gamesComplete;


- (void)dealloc {
  [cellWrapper release];
  [gameListTableView release];
  [navItem release];
  [addButton release];
  [setUpController release];
  [gameController release];
  
  [managedObjectContext release];
  [gamesInProgress release];
  [gamesComplete release];
  
  [super dealloc];
}

- (IBAction) newGame:(id)sender {
  [[self.managedObjectContext undoManager] beginUndoGrouping];
  [[self.managedObjectContext undoManager] setActionName:@"new game"];

  Game* g = (Game*)[NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
  Setting* s = (Setting*)[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.managedObjectContext];
  g.setting = s;

  [self.setUpController initWithGame:g];
  [self.navigationController pushViewController:self.setUpController animated:YES];
}

- (void) loadGames {
  NSPredicate* inProgress = [NSPredicate predicateWithFormat:@"winningTeam == nil"];
  NSPredicate* complete = [NSPredicate predicateWithFormat:@"winningTeam != nil"];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setIncludesSubentities:YES];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastPlayed" ascending:NO];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptor release];
  
  NSError *error;
  NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
  [self setGamesInProgress:[NSMutableArray arrayWithArray:[mutableFetchResults filteredArrayUsingPredicate:inProgress]]];
  [self setGamesComplete:[NSMutableArray arrayWithArray:[mutableFetchResults filteredArrayUsingPredicate:complete]]];

  [mutableFetchResults release];
  [request release];
  
  [self.gameListTableView reloadData];
}

- (Game*) gameForIndexPath:(NSIndexPath*)index {
  return [[self valueForSection:index.section valueInProgress:self.gamesInProgress valueCompleted:self.gamesComplete] objectAtIndex:index.row];
}

- (id) valueForSection:(NSInteger)section valueInProgress:(id)valueInProgress valueCompleted:(id)valueCompleted {
  id val = nil;
  
  if ([self.gamesInProgress count] == 0 && [self.gamesComplete count] > 0) {
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
  
  self.title = @"Game List";

  [self.navigationItem setRightBarButtonItem:self.addButton animated:NO];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self loadGames];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
  int sections = 0;
  
  if ([self.gamesInProgress count] > 0) {
    sections++;
  }
  if ([self.gamesComplete count] > 0) {
    sections++;
  }
  
	return sections;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return [self valueForSection:section valueInProgress:ssTitleInProgress valueCompleted:ssTitleCompleted];
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self valueForSection:section valueInProgress:[NSNumber numberWithInteger:[self.gamesInProgress count]] valueCompleted:[NSNumber numberWithInteger:[self.gamesComplete count]]] integerValue];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellGame";
  
  CellGame* cellGame = (CellGame*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellGame == nil) {
    [self.cellWrapper loadMyNibFile:CellIdentifier];
    cellGame = (CellGame*)self.cellWrapper.cell;
  }

  Game* g = [self gameForIndexPath:indexPath];
  
  cellGame.nameTeamOne.text = [g nameForPosition:0];
  cellGame.nameTeamTwo.text = [g nameForPosition:1];
  cellGame.pointsTeamOne.text = [g scoreForPosition:0];
  cellGame.pointsTeamTwo.text = [g scoreForPosition:1];
  
  // show icon for winning team
  if (!g.isComplete) {
    cellGame.symbolResultTeamOne.hidden = YES;
    cellGame.symbolResultTeamTwo.hidden = YES;
  }
  else if ([g isVictorInPosition:0]) {
    cellGame.symbolResultTeamOne.hidden = NO;
  }
  else if ([g isVictorInPosition:1]) {
    cellGame.symbolResultTeamTwo.hidden = NO;
  }
  
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterMediumStyle];
  
  cellGame.dateLastPlayed.text = [formatter stringFromDate:g.lastPlayed];

  [formatter release];
  
  return cellGame;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  [self setEditing:NO animated:NO];
  [self.gameController initWithGame:[self gameForIndexPath:indexPath]];
  [self.navigationController pushViewController:self.gameController animated:YES];
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [managedObjectContext deleteObject:[self gameForIndexPath:indexPath]];
    NSError* err = nil;

    if (![managedObjectContext save:&err]) {
      NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
    }

    [self loadGames];
  }
}

@end