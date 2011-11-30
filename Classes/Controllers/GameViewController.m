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
@synthesize highestBidderController;
@synthesize roundsTableView;
@synthesize cellWrapper;
@synthesize addButton;
@synthesize rematchButton;
@synthesize teamOneName;
@synthesize teamTwoName;
@synthesize bidButton;
@synthesize congratulations;
@synthesize dividerTop;

@synthesize game;

- (void) dealloc {
  [highestBidderController release];
  [roundsTableView release];
  [cellWrapper release];
  [addButton release];
  [rematchButton release];
  [teamOneName release];
  [teamTwoName release];
  [bidButton release];
  [congratulations release];
  [dividerTop release];
  
  [game release];
  
  [super dealloc];
}

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
  [newGameView release];
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

  [self.roundsTableView reloadData];
  [self.roundsTableView scrollsToTop];
  [self gameComplete];
}

- (void) gameComplete {
  self.bidButton.hidden         = NO;
  self.congratulations.hidden   = YES;

  [self.navigationItem setRightBarButtonItem:self.addButton animated:NO];
  
  if ([self.game.isComplete boolValue]) {
    NSString* winningTeamNames = [self.game teamNames:self.game.winningTeams];

    [self.congratulations setTitle:[NSString stringWithFormat:@"%@ won! Rematch?", winningTeamNames] forState:UIControlStateNormal];
    self.bidButton.hidden       = YES;
    self.congratulations.hidden = NO;
    [self.navigationItem setRightBarButtonItem:self.rematchButton animated:NO];
    if ([[NSDate date] timeIntervalSinceDate:self.game.lastPlayed] < 2) {
      NSString* msg = [NSString stringWithFormat:@"%@ win!", winningTeamNames];
      UIAlertView* rematchAlert = [[[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Rematch", nil] autorelease];
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
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.game.rounds count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellScoringRound";
  
  CellScoringRound* cellScoringRound = (CellScoringRound*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cellScoringRound == nil) {
    [cellWrapper loadMyNibFile:CellIdentifier];
    cellScoringRound = (CellScoringRound*)cellWrapper.cell;
  }
  
  [cellScoringRound setStyleForRound:[self.game.rounds objectAtIndex:indexPath.row]];

  return cellScoringRound;
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  return nil;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  BOOL canEdit = NO;

  if (0 == indexPath.row) {
    canEdit = YES;
  }
  return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.game removeObjectFromRoundsAtIndex:indexPath.row];
    [self.game save];

    [self refreshView];
  }
}

@end
