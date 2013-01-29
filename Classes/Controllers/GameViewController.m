#import "GameViewController.h"
#import "Game.h"
#import "Round.h"
#import "ScoreFiveHundredAppDelegate.h"

@interface GameViewController()

- (NSString*) nonBlankFirst:(NSString*)first OtherwiseSecond:(NSString*)second;
- (void) refreshView;
- (void) gameComplete;

@end


@implementation GameViewController

// MARK: synthesize
@synthesize
  highestBidderController,
  roundsTableView,
  cellWrapper,
  addButton,
  rematchButton,
  teamOneName,
  teamTwoName,
  teamOneScore,
  teamTwoScore,
  game;


- (IBAction) bid:(id)sender {
  [self setEditing:NO animated:NO];
  [self.highestBidderController initWithGame:self.game];
  [self.navigationController pushViewController:self.highestBidderController animated:YES];
}

- (IBAction) rematch:(id)sender {
  UINavigationController* navController = self.navigationController;
  GameViewController* newGameView = [GameViewController alloc];
  [newGameView initWithGame:[self.game duplicate]];
  
  [navController popViewControllerAnimated:NO];
  [navController pushViewController:newGameView animated:YES];
}

- (void) initWithGame:(Game*)g {
  self.game = g;
}

// MARK: Hidden functions
- (NSString*) nonBlankFirst:(NSString*)first OtherwiseSecond:(NSString*)second {
  if (first == nil || [@"" isEqual:first]) {
    return second;
  }
  
  return first;
}

- (void) refreshView {
  self.teamOneName.text = [self.game nameForPosition:0];
  self.teamTwoName.text = [self.game nameForPosition:1];
  if ([self.game scoreForPosition:0] == nil) {
    self.teamOneScore.text = @"0";
  }
  else {
    self.teamOneScore.text = [self.game scoreForPosition:0];    
  }
  if ([self.game scoreForPosition:1] == nil) {
    self.teamTwoScore.text = @"0";
  }
  else {
    self.teamTwoScore.text = [self.game scoreForPosition:1];
  }

  [self.roundsTableView reloadData];
  [self.roundsTableView scrollsToTop];
  [self gameComplete];
}

- (void) gameComplete {
  [self.navigationItem setRightBarButtonItem:self.addButton animated:NO];

  if ([self.game.isComplete boolValue]) {
    NSString* winningTeamNames = [self.game teamNames:self.game.winningTeams];

    [self.navigationItem setRightBarButtonItem:self.rematchButton animated:NO];
    if ([[NSDate date] timeIntervalSinceDate:self.game.lastPlayed] < 2) {
      NSString* msg = [NSString stringWithFormat:@"%@ win!", winningTeamNames];
      UIAlertView* rematchAlert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Rematch", nil];
      [rematchAlert show];
    }
  }
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Game";
  
  [self.navigationItem setRightBarButtonItem:self.addButton animated:NO];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self refreshView];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

// MARK: AlertView delegate
- (void) alertView:(UIAlertView*)alert didDismissWithButtonIndex:(NSInteger)index {
  if (index == 1) {
    [self rematch:@"alertView"];
  }
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 2;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0 && [self.game.rounds count] > 0) {
    return @"Rounds";
  }

  return nil;
}


- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return [self.game.rounds count];
  }
  
  return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.section == 0) {
    static NSString* CellIdentifier = @"CellScoringRound";
    
    CellScoringRound* cellScoringRound = (CellScoringRound*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cellScoringRound == nil) {
      [cellWrapper loadMyNibFile:CellIdentifier];
      cellScoringRound = (CellScoringRound*)cellWrapper.cell;
    }
    
    [cellScoringRound setStyleForRound:[self.game.rounds reversedOrderedSet][indexPath.row]];

    return cellScoringRound;
  }
  else {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellAddButton"];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 0, CGRectGetWidth(cell.contentView.bounds)-20, CGRectGetHeight(cell.contentView.bounds)+3);
    if ([self.game.isComplete boolValue]) {
      NSString* winningTeamNames = [self.game teamNames:self.game.winningTeams];

      [btn setTitle:[NSString stringWithFormat:@"%@ won! Rematch?", winningTeamNames] forState:UIControlStateNormal];
      [btn addTarget:self action:@selector(rematch:) forControlEvents:UIControlEventTouchUpInside];      
    }
    else {
      [btn setTitle:@"Add round" forState:UIControlStateNormal];
      [btn addTarget:self action:@selector(bid:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell addSubview:btn];
    
    return cell;
  }
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  return nil;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  BOOL canEdit = NO;

  if ([self.game.rounds count]-1 == indexPath.row) {
    canEdit = YES;
  }
  return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.game removeObjectFromRoundsAtIndex:0];
    [self.game save];

    [self refreshView];
  }
}

@end
