//
//  RoundScore.h
//  ScoreFiveHundred
//
//  Created by Benjamin Walsham on 06/11/2011.
//  Copyright (c) 2011 MeltingWaldo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round, Team;

@interface RoundScore : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * tricksWon;
@property (nonatomic, retain) Round *round;
@property (nonatomic, retain) Team *team;

@end
