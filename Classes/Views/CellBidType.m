#import "CellBidType.h"

@implementation CellBidType

@synthesize symbol;
@synthesize description;
@synthesize points;

- (void)dealloc {
  [symbol release];
  [description release];
  [points release];

  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
