//
//  ParseManager.h
//  Symeetry
//
//  Created by Charles Northup on 4/15/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

@class CoreLocation;
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"


@interface ParseManager : NSObject

//user related methods
+(PFUser*)currentUser;
+(NSArray*)getUsers;
+(BOOL)isCurrentUser:(PFUser*)user;
+(PFObject*)getInterest:(PFUser*)user;

//saving and object update methods
+(void)saveInfo:(PFUser*)user objectToSet:(id)object forKey:(NSString*)key;
+(void)updateInterest:(NSDictionary*)interests forUser:(NSString*)userId;
+(void)addLocation:(CLLocation*)location forUser:(NSString*)userId atBeacon:(NSString*)uuid;
+(void)retrieveLocationFor:(NSString*)userId location:(NSArray*)locations;


//helper method
+(void)addBeaconWithName:(NSString*)name withUUID:(NSString*)uuid;
+(PFFile*)convertUIImageToPFFile:(UIImage*)image;



@end
