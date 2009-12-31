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
  IBOutlet UILabel *teamOneResult;
  IBOutlet UILabel *teamTwoResult;
  
  NSMutableDictionary *game;
  NSString *gameKey;
  NSMutableArray *rounds;
  NSNumber *slotTeamOne;
  NSNumber *slotTeamTwo;
  NSString *oldNameTeamOne;
  NSString *oldNameTeamTwo;
  NSNumber *winningSlot;
  NSDate *lastPlayed;
  BOOL newGame;
}

@property (nonatomic, retain) IBOutlet UITableView *roundsTableView;
@property (nonatomic, retain) IBOutlet CellWrapper *cellWrapper;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) IBOutlet UITextField *teamOneName;
@property (nonatomic, retain) IBOutlet UITextField *teamTwoName;
@property (nonatomic, retain) IBOutlet UIButton *teamOneBid;
@property (nonatomic, retain) IBOutlet UIButton *teamTwoBid;
@property (nonatomic, retain) IBOutlet UILabel *teamOneResult;
@property (nonatomic, retain) IBOutlet UILabel *teamTwoResult;

@property (nonatomic, retain) NSMutableDictionary *game;
@property (nonatomic, retain) NSString *gameKey;
@property (nonatomic, retain) NSMutableArray *rounds;
@property (nonatomic, retain) NSNumber *slotTeamOne;
@property (nonatomic, retain) NSNumber *slotTeamTwo;
@property (nonatomic, retain) NSString *oldNameTeamOne;
@property (nonatomic, retain) NSString *oldNameTeamTwo;
@property (nonatomic, retain) NSNumber *winningSlot;
@property (nonatomic, getter=isNewGame) BOOL newGame;
@property (nonatomic, retain) NSDate *lastPlayed;

- (IBAction) edit:(id)sender;

- (void) openGameForKey:(NSString *)key AndIsNewGame:(BOOL)isNewGame;
- (void) updateRound:(BOOL)updateRound ForTeamSlot:(NSNumber *)teamOneOrTwo ForHand:(NSString *) hand AndTricksWon:(NSNumber *)tricksWon;

- (NSString *) teamNameForSlot:(NSNumber *)slot;

@end
