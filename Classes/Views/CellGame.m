#import "CellGame.h"

@implementation CellGame

@synthesize nameTeamOne;
@synthesize nameTeamTwo;
@synthesize pointsTeamOne;
@synthesize pointsTeamTwo;
@synthesize symbolResultTeamOne;
@synthesize symbolResultTeamTwo;
@synthesize dateLastPlayed;

// MARK: UITableViewCell functions
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
