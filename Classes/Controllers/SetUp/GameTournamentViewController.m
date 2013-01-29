#import "GameTournamentViewController.h"

@implementation GameTournamentViewController

// MARK: synthesize
@synthesize table;
@synthesize setting;
@synthesize tournamentOptions;


- (void) initWithSetting:(Setting*)s {
  self.setting = s;
  
  self.tournamentOptions = [NSOrderedSet orderedSetWithObjects:
                            @0,
                            @1,
                            @2,
                            @3,
                            @4,
                            @5,
                            @6,
                            @7,
                            @8,
                            @9,
                            @10,
                            @15,
                            @20,
                            nil];
}


// MARK: view
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"# Rounds";
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {  
  return nil;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.tournamentOptions count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellTournament = @"CellTournament";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellTournament];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTournament];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  cell.textLabel.text = [self.setting textForTournament:[(self.tournamentOptions)[indexPath.row] intValue]];
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  self.setting.tournament = (self.tournamentOptions)[indexPath.row];

  [self.navigationController popViewControllerAnimated:YES];
}

@end
