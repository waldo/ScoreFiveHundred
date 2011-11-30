#import "TricksWonViewController.h"
#import "GameViewController.h"


@implementation TricksWonViewController

static NSString* ssBidVariationRegular = @"regular";
static NSString* ssBidVariationMisere = @"misére";
static NSString* ssBidVariationNoBid = @"no bid";
static int siMaximumTricks = 10;

// MARK: synthesize
@synthesize
  gameController,
  scoreController,
  tricksWonTableView,
  game,
  round,
  team,
  bidVariation,
  regularList,
  misereList;


- (void) dealloc {
  [gameController release];
  [scoreController release];
  [tricksWonTableView release];

  [game release];
  [round release];
  [team release];
  [bidVariation release];
  [regularList release];
  [misereList release];
  
  [super dealloc];
}

- (NSArray*) tricksWonList {
  NSArray* list = nil;
  
  if ([self.bidVariation isEqualToString:ssBidVariationMisere]) {
    list = self.misereList;
  }
  else {
    list = self.regularList;
  }

  return list;
}

- (void) initWithGame:(Game*)g round:(Round*)r andTeam:(Team*)t {
  self.game = g;
  self.round = r;
  self.team = t;
  self.bidVariation = [BidType variation:self.round.bid];

  self.title = [NSString stringWithFormat:@"%@", self.team.name];
}

// MARK: View
- (void) viewDidLoad {
  [super viewDidLoad];

  self.regularList = [NSArray arrayWithObjects:
                      @"10 tricks",
                      @"9 tricks",
                      @"8 tricks",
                      @"7 tricks",
                      @"6 tricks",
                      @"5 tricks",
                      @"4 tricks",
                      @"3 tricks",
                      @"2 tricks",
                      @"1 trick",
                      @"0 tricks", 
                      nil
                      ];
  
  self.misereList = [NSArray arrayWithObjects:
                     @"Won by losing every trick",
                     @"Got one or more tricks",
                     nil
                     ];

  [self.scoreController setStandardFrame];  
  [self.view addSubview:self.scoreController.view];
  self.gameController = [self.navigationController.viewControllers objectAtIndex:1];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.scoreController initWithGame:self.game];
  [self.tricksWonTableView reloadData];
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {	
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
  return @"";
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self tricksWonList] count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellTricksWon";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }

  int score = 0;
  int tricksWon = 0;
  
  if ([self.bidVariation isEqualToString:ssBidVariationMisere]) {
    tricksWon = indexPath.row;
  }
  else {
    tricksWon = (siMaximumTricks - indexPath.row);
  }

  score = [BidType pointsForTeam:self.team game:self.game andTricksWon:tricksWon];
    
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [[self tricksWonList] objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%i pts", score];
  [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
  if (score > 0) {
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:53.0/255.0 green:102.0/255.0 blue:201.0/255.0 alpha:1.0]];
  }
  else {
    [cell.detailTextLabel setTextColor:[UIColor redColor]];
  }
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  int tricksWon = 0;
  
  if (![self.bidVariation isEqual:@"misére"]) {
    tricksWon = 10 - indexPath.row;
  }
  else {
    tricksWon = indexPath.row;
  }
  
  [self.round updateAndSetTricksWon:tricksWon forTeam:self.team];
  if ([self.game.setting.mode isEqualToString:@"2 teams"] || [self.game.setting.mode isEqualToString:@"Quebec mode"] || [self.bidVariation isEqualToString:@"misére"]) {
    [self.game finaliseRound];    
    [self.navigationController popToViewController:self.gameController animated:YES];
  }
  else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
