#import "HighestBiddingTeamViewController.h"


@interface HighestBiddingTeamViewController ()

@property Game *game;
@property Round *round;

- (IBAction)cancel:(id)sender;

@end

@implementation HighestBiddingTeamViewController

#pragma mark Public

- (void)initWithGame:(Game *)g {
  self.game = g;
  self.round = [_game buildRound];
}

#pragma mark Private

- (IBAction)cancel:(id)sender {
  [_delegate cancelRoundForGame:_game fromController:self];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ScoreSummary"]) {
    [((ScoreMiniViewController *)segue.destinationViewController) initWithGame:_game];
  }
  else if ([segue.identifier isEqualToString:@"HighestBidder"]) {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    [_round setBiddingTeams:nil];
    [_round addBiddingTeamsObject:_game.teams[indexPath.row]];

    BiddingViewController *controller = segue.destinationViewController;
    [controller initWithGame:_game];
    controller.delegate = _delegate;
  }
  else if ([segue.identifier isEqualToString:@"NoBidder"]) {
    _round.bid = @"NB";
    TricksWonViewController *controller = segue.destinationViewController;
    [controller initWithGame:_game andTeam:_game.teams[0]];
    controller.delegate = _delegate;
  }
}

#pragma mark View

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

#pragma mark Tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if ([_game.setting isPlayOnNoOneBid]) {
    return 2;    
  }

  return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return _game.teams.count;
  }

  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  if (indexPath.section == 0) {
    cell.textLabel.text = [_game.teams[indexPath.row] name];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    [self performSegueWithIdentifier:@"HighestBidder" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
  }
}

@end
