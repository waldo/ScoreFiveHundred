//
//  GameViewController.h
//
//  Created by Ben Walsham on 23/12/2009.
//  Copyright 2009 MeltingWaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BidType.h"
#import "CellWrapper.h"
#import "CellScoringRound.h"

@interface GameViewController : UIViewController {
  IBOutlet UITableView *roundsTableView;
  CellWrapper *cellWrapper;
  IBOutlet UILabel *teamOneName;
  IBOutlet UILabel *teamTwoName;
  
  NSMutableArray *rounds;
  NSNumber *teamOneSlot;
  NSNumber *teamTwoSlot;
}

@property (nonatomic, retain) IBOutlet UITableView *roundsTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UILabel *teamOneName;
@property (nonatomic, retain) IBOutlet UILabel *teamTwoName;

@property (nonatomic, retain) NSMutableArray *rounds;
@property (nonatomic, retain) NSNumber *teamOneSlot;
@property (nonatomic, retain) NSNumber *teamTwoSlot;


- (void) updateRound:(BOOL)updateRound ForTeamSlot:(NSNumber *)teamOneOrTwo ForHand:(NSString *) hand AndTricksWon:(NSNumber *)tricksWon;

- (NSString *) teamNameForSlot:(NSNumber *)slot;

@end
