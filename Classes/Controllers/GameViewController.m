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
@synthesize editButton;
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
  [editButton release];
  [teamOneName release];
  [teamTwoName release];
  [bidButton release];
  [congratulations release];
  [dividerTop release];
  
  [game release];
  
  [super dealloc];
}

- (IBAction) edit:(id)sender {
  [self setEditing:!self.editing animated:YES];
}

- (IBAction) bid:(id)sender {
  [self setEditing:NO animated:NO];
  [self.highestBidderController initWithGame:self.game];
  [self.navigationController pushViewController:self.highestBidderController animated:YES];
}

- (IBAction) rematch:(id)sender {
  self.game = [self.game duplicate];
  [self refreshView];
}

- (void) initWithGame:(Game*)g {
  self.game = g;

  [self.game save];
}

- (void) addFinalisedRound:(Round*)r {
  [self.game insertObject:r inRoundsAtIndex:0];
  [self.game save];

  if (self.game.isComplete) {
    NSString* winningTeamName = [self.game.winningTeam name];
    NSString* msg = [NSString stringWithFormat:@"%@ win!", winningTeamName];
    UIAlertView* rematchAlert = [[[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Rematch", nil] autorelease];
    [rematchAlert show];
  }
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
  NSString* team                = nil;
  
  if ([self.game.isComplete boolValue]) {    
    team = [self.game.winningTeam name];

    [self.congratulations setTitle:[NSString stringWithFormat:@"%@ won! Rematch?", team] forState:UIControlStateNormal];
    self.bidButton.hidden       = YES;
    self.congratulations.hidden = NO;
  }
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Game";
  
  [self.navigationItem setRightBarButtonItem:self.editButton animated:YES];
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
  // never selectable
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
