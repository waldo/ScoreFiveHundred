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
  IBOutlet UIBarButtonItem *editButton;
  IBOutlet UITextField *teamOneName;
  IBOutlet UITextField *teamTwoName;
  IBOutlet UIButton *teamOneBid;
  IBOutlet UIButton *teamTwoBid;
  
  NSMutableArray *rounds;
  NSNumber *teamOneSlot;
  NSNumber *teamTwoSlot;
  NSString *teamOneOldName;
  NSString *teamTwoOldName;
}

@property (nonatomic, retain) IBOutlet UITableView *roundsTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) IBOutlet UITextField *teamOneName;
@property (nonatomic, retain) IBOutlet UITextField *teamTwoName;
@property (nonatomic, retain) IBOutlet UIButton *teamOneBid;
@property (nonatomic, retain) IBOutlet UIButton *teamTwoBid;

@property (nonatomic, retain) NSMutableArray *rounds;
@property (nonatomic, retain) NSNumber *teamOneSlot;
@property (nonatomic, retain) NSNumber *teamTwoSlot;
@property (nonatomic, retain) NSString *teamOneOldName;
@property (nonatomic, retain) NSString *teamTwoOldName;


- (IBAction) edit:(id)sender;

- (void) updateRound:(BOOL)updateRound ForTeamSlot:(NSNumber *)teamOneOrTwo ForHand:(NSString *) hand AndTricksWon:(NSNumber *)tricksWon;

- (NSString *) teamNameForSlot:(NSNumber *)slot;

@end
