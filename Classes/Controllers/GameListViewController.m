#import "GameListViewController.h"
#import "Game.h"
#import "Setting.h"

@implementation GameListViewController

// MARK: static
static NSString* ssTitleInProgress    = @"In Progress";
static NSString* ssTitleCompleted     = @"Complete";

// MARK: synthesize
@synthesize 
  cellWrapper,
  gameListTableView,
  addButton,
  setUpController,
  gameController,
  managedObjectContext,
  gamesInProgress,
  gamesComplete,
  mostRecentGame;


- (void)dealloc {
  [cellWrapper release];
  [gameListTableView release];
  [addButton release];
  [setUpController release];
  [gameController release];
  
  [managedObjectContext release];
  [gamesInProgress release];
  [gamesComplete release];
  [mostRecentGame release];
  
  [super dealloc];
}

- (IBAction) newGame:(id)sender {
  [[self.managedObjectContext undoManager] beginUndoGrouping];
  [[self.managedObjectContext undoManager] setActionName:@"new game"];

  Game* g = (Game*)[NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:self.managedObjectContext];
  Setting* s = (Setting*)[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.managedObjectContext];
  g.setting = s;

  [self.setUpController initWithGame:g mostRecentSettings:self.mostRecentGame.setting];
  [self.navigationController pushViewController:self.setUpController animated:YES];
}

- (void) loadGames {
  NSPredicate* inProgress = [NSPredicate predicateWithFormat:@"winningTeams.@count == 0"];
  NSPredicate* complete = [NSPredicate predicateWithFormat:@"winningTeams.@count > 0"];
  
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
  
  if ([mutableFetchResults count] > 0) {
    self.mostRecentGame = [mutableFetchResults objectAtIndex:0];
  }
  else {
    self.mostRecentGame = nil;
  }

  [self setGamesInProgress:[NSMutableArray arrayWithArray:[mutableFetchResults filteredArrayUsingPredicate:inProgress]]];
  [self setGamesComplete:[NSMutableArray arrayWithArray:[mutableFetchResults filteredArrayUsingPredicate:complete]]];

  [mutableFetchResults release];
  [request release];
  
  [self.gameListTableView reloadData];
}

- (Game*) gameForIndexPath:(NSIndexPath*)index {
  if (index.section == 0) {
    return [self.gamesInProgress objectAtIndex:index.row];
  }
  else if (index.section == 1) {
    return [self.gamesComplete objectAtIndex:index.row];
  }
  
  return nil;
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
	return 3;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0 && [self.gamesInProgress count] > 0) {
    return @"In progress";
  }
  else if (section == 1 && [self.gamesComplete count] > 0) {
    return @"Complete";
  }

  return nil;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return [self.gamesInProgress count];
  }
  else if (section == 1) {
    return [self.gamesComplete count];
  }
  
  return 1;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.section == 2) {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellAddButton"] autorelease];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 0, CGRectGetWidth(cell.contentView.bounds)-20, CGRectGetHeight(cell.contentView.bounds)+3);
    [btn setTitle:@"New game" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(newGame:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];

    return cell;
  }
  else {
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
    if ([g isVictorInPosition:0]) {
      cellGame.symbolResultTeamOne.hidden = NO;
    }
    if ([g isVictorInPosition:1]) {
      cellGame.symbolResultTeamTwo.hidden = NO;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    cellGame.dateLastPlayed.text = [formatter stringFromDate:g.lastPlayed];

    [formatter release];
    
    return cellGame;
  }
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