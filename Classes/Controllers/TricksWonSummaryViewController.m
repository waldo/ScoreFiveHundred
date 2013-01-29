#import "TricksWonSummaryViewController.h"
#import "GameViewController.h"

@implementation TricksWonSummaryViewController

// MARK: synthesize
@synthesize
  gameController,
  tricksWonController,
  scoreController,
  table,
  saveButton,
  game,
  round;


- (void) initWithGame:(Game*)g andRound:(Round*)r {
  self.game = g;
  self.round = r;
  
  self.title = @"Tricks won";
}

- (IBAction) save:(id)sender {
  [self.game finaliseRound];
  
  [self.navigationController popToViewController:self.gameController animated:YES];
}

// MARK: view lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.scoreController setStandardFrame];
  [self.view addSubview:self.scoreController.view];
  [self.navigationItem setRightBarButtonItem:self.saveButton animated:NO];
  self.gameController = (self.navigationController.viewControllers)[1];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.scoreController initWithGame:self.game];
  [self.table reloadData];
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  if ([self.round.bid isEqualToString:@"NB"]) {
    return [NSString stringWithFormat:@"%@", [BidType tricksAndDescriptionForHand:self.round.bid]];
  }

  return [NSString stringWithFormat:@"%@ bid %@", [[self.round.biddingTeams anyObject] name], [BidType tricksAndDescriptionForHand:self.round.bid]];
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.game.teams count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellTeams";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  NSString* tricksWon = [self.round tricksWonForPosition:indexPath.row];

  cell.textLabel.text = [self.game nameForPosition:indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%d tricks", [tricksWon intValue]];
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  [self.tricksWonController initWithGame:self.game round:self.round andTeam:(self.game.teams)[indexPath.row]];

  [self.navigationController pushViewController:self.tricksWonController animated:YES];
}

@end
