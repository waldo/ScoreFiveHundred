#import "GameTournamentViewController.h"

@implementation GameTournamentViewController

// MARK: synthesize
@synthesize table;
@synthesize setting;

- (void) dealloc {
  [table release];
  [setting release];

  [super dealloc];
}


- (void) initWithSetting:(Setting *)s {
  self.setting = s;
}


// MARK: view
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Tournament - # Rounds";
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
  return [self.setting.tournamentOptions count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellTournament = @"CellTournament";
  
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellTournament];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTournament] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  cell.textLabel.text = [self.setting textForTournament:indexPath.row];
  
  return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  self.setting.tournament = [self.setting.tournamentOptions objectAtIndex:indexPath.row];

  [self.navigationController popViewControllerAnimated:YES];
}

@end
