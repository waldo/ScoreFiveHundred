#import "HighestBiddingTeamViewController.h"
#import "ScoreFiveHundredAppDelegate.h"


@implementation HighestBiddingTeamViewController

// MARK: static
static NSString* ssTitleTeam      = @"Highest bidders";
static NSString* ssTitleNoBid     = @"No-one bid - play a no-trumps round for 10 points per trick";

// MARK: synthesize
@synthesize
  biddingController,
  tricksWonSummaryController,
  tricksWonController,
  teamSelectionTableView,
  scoreController,
  cancelButton,
  game,
  round;

- (void)dealloc {
  [biddingController release];
  [tricksWonSummaryController release];
  [tricksWonController release];
  [teamSelectionTableView release];
  [scoreController release];
  [cancelButton release];

  [game release];
  [round release];
  
  [super dealloc];
}

- (void) initWithGame:(Game*)g {
  self.game = g;
  self.round = [self.game buildRound];
}

- (IBAction) cancel:(id)sender {
  if ([self.game.managedObjectContext.undoManager.undoActionName isEqualToString:@"new round"]) {
    [self.game.managedObjectContext.undoManager endUndoGrouping];
    [self.game.managedObjectContext.undoManager undo];
  }

  [self.navigationController popViewControllerAnimated:YES];
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Bidding Team";

  [self.scoreController setStandardFrame];  
  [self.view addSubview:self.scoreController.view];
  [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:NO];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.scoreController initWithGame:self.game];
  [self.teamSelectionTableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void) viewWillUnload {
  if ([self.game.managedObjectContext.undoManager.undoActionName isEqualToString:@"new round"]) {
    [self.game.managedObjectContext.undoManager endUndoGrouping];
    [self.game.managedObjectContext.undoManager undo];
  }
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
  if ([self.game.setting isPlayOnNoOneBid]) {
    return 2;    
  }

  return 1;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return [self.game.teams count];
  }

  return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return ssTitleTeam;
  }
  
  return ssTitleNoBid;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString *TeamIdentifier = @"TeamSelection";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeamIdentifier] autorelease];
  }
  
  if (indexPath.section == 0) {
    cell.textLabel.text = [self.game nameForPosition:indexPath.row];
  }
  else {
    cell.textLabel.text = @"No bid";
  }

  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  [self.round setBiddingTeams:nil];

  if (indexPath.section == 0) {
    [self.round addBiddingTeamsObject:[self.game.teams objectAtIndex:indexPath.row]];
    [self.biddingController initWithGame:self.game andRound:self.round];
    [self.navigationController pushViewController:self.biddingController animated:YES];
  }
  else {
    self.round.bid = @"NB";

    if ([self.game.setting.mode isEqualToString:@"2 teams"] || [self.game.setting.mode isEqualToString:@"Quebec mode"]) {
      [self.tricksWonController initWithGame:self.game round:self.round andTeam:[self.game.teams firstObject]];
      [self.navigationController pushViewController:self.tricksWonController animated:YES];
    }
    else {
      [self.tricksWonSummaryController initWithGame:self.game andRound:self.round];
      [self.navigationController pushViewController:self.tricksWonSummaryController animated:YES];
    }
  }
}

@end