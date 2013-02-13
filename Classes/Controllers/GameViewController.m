#import "GameViewController.h"
#import "Game.h"
#import "Round.h"
#import "ScoreFiveHundredAppDelegate.h"


@interface GameViewController ()

- (NSString *)nonBlankFirst:(NSString *)first otherwiseSecond:(NSString *)second;
- (void)refreshView;
- (void)gameComplete;

@end

@implementation GameViewController

- (void)initWithGame:(Game *)g {
  self.game = g;
}

- (IBAction)rematch:(id)sender {
  [_delegate rematchForGame:_game fromController:self];
}

// MARK: Hidden functions
- (NSString *)nonBlankFirst:(NSString *)first otherwiseSecond:(NSString *)second {
  if (first == nil || [@"" isEqual:first]) {
    return second;
  }
  
  return first;
}

- (void)refreshView {
  [self.scoreSummary initWithGame:_game];

  [self.tableView reloadData];
  [self.tableView scrollsToTop];
  [self gameComplete];
}

- (void)gameComplete {
  [self.navigationItem setRightBarButtonItem:self.addBarButton animated:NO];
  _addButton.hidden = NO;
  _rematchButton.hidden = YES;

  if (self.game.isComplete.boolValue) {
    NSString *winningTeamNames = [self.game teamNames:self.game.winningTeams];
    [self.navigationItem setRightBarButtonItem:self.rematchBarButton animated:NO];
    _addButton.hidden = YES;
    _rematchButton.hidden = NO;
    _rematchButton.titleLabel.text = [NSString stringWithFormat:@"%@ win! Rematch?", winningTeamNames];

    if ([[NSDate date] timeIntervalSinceDate:self.game.lastPlayed] < 2) {
      NSString *msg = [NSString stringWithFormat:@"%@ win!", winningTeamNames];
      UIAlertView *rematchAlert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Rematch", nil];
      [rematchAlert show];
    }
  }
}

// MARK: RoundDelegate
- (void)cancelRoundForGame:(Game *)g fromController:(UIViewController *)controller {
  [g undoRound];

  [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyRoundForGame:(Game *)g fromController:(UIViewController *)controller {
  [self.navigationController popToViewController:self animated:YES];
}

// MARK: Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    self.scoreSummary = segue.destinationViewController;
    [_scoreSummary initWithGame:_game];
  }
  else if ([segue.identifier rangeOfString:@"NewRound"].location == 0) {
    [self setEditing:NO animated:NO];
    HighestBiddingTeamViewController *controller = segue.destinationViewController;
    [controller initWithGame:_game];
    controller.delegate = self;
  }
}

// MARK: View
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self refreshView];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

// MARK: AlertView delegate
- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)index {
  if (index == 1) {
    [self rematch:@"alertView"];
  }
}

// MARK: tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"Rounds";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _game.rounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CellScoringRound *cell = [tableView dequeueReusableCellWithIdentifier:@"Round"];

  [cell setStyleForRound:[_game.rounds reversedOrderedSet][indexPath.row]];

  return cell;
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  return nil;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
  BOOL canEdit = NO;

  if (self.game.rounds.count - 1 == indexPath.row) {
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
