//
//  ParseManager.m
//  Symeetry
//
//  Created by Charles Northup on 4/15/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import "ParseManager.h"
#import "SimilarityAlgorithm.h"

@implementation ParseManager

/*
 * Get the current user logged into the system
 */
+(PFUser*)currentUser
{
    return [PFUser currentUser];
}

/*Logs in User if not already logged in
 *Signs the user up if they are new
 *Logs the new user in
 */

+(void)logInOrSignUp:(NSString*)username
            password:(NSString*)password
          comfirming:(NSString*)comfirmPassword
               email:(NSString*)email
     completionBlock:(void (^)(void))completionBlock
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error) {
            if ([password isEqualToString:comfirmPassword])
            {
                PFUser* newUser = [PFUser new];
                [newUser setUsername:username];
                [newUser setPassword:password];
                [newUser setEmail:email];
                [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        completionBlock();
                    }
                }];
            }
            
        }
        else {
            completionBlock();
        }
    }];
}

/*
 * Query the Parse backend to find the list of all users in the system who are not
 * the current user
 * @return NSArray array of PFUser objects
 */
+(NSArray*)getUsers
{
    PFQuery* query = [PFUser query];
    //[query whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
    return [query findObjects];
}

/*
 *
 */
+(NSArray*)retrieveUsersWithInterests
{

    PFQuery* query = [PFUser query];
    [query whereKey:@"userId" notEqualTo:[[PFUser currentUser] objectId]]; //exclude the current user
    [query includeKey:@"interests"];
    return [query findObjects];
}


/*
 * TODO: THIS QUERY NEEDS TO BE ASYNCHRONOUS
 * Query the Parse backend to find the interest of the user based on the
 * user's specific id
 * @return PFObject the Parse Interest object for the specified user
 */
+(PFObject*)getInterest:(PFUser*)user
{
    PFQuery* query = [PFQuery queryWithClassName:@"Interests"];
    [query whereKey:@"userid" equalTo:user.objectId];
    return [[query findObjects] firstObject];
}


/*
 * @ param PFUser user
 * @ return BOOL yes if it is the current user, no otherwise
 */
+(BOOL)isCurrentUser:(PFUser*)user
{
    if ([user.username isEqualToString:[[PFUser currentUser] username]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
 * checks to see if current user is true then modifies the object(object) at the desired key(key)
 * then saves in background
 * @ param PFUser user
 * @ param id object
 * @ param forKey key
 * @ return void
 */
+(void)saveInfo:(PFUser*)user objectToSet:(id)object forKey:(NSString*)key completionBlock:(void (^)(void))completionBlock
{
    if ([self isCurrentUser:user])
    {
        [[PFUser currentUser] setObject:object forKey:key];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                completionBlock();
            }];
        }];
    }
}



/*
 * Stub method to update the user's interest on Parse
 */
+(void)updateInterest:(NSDictionary*)interests forUser:(NSString*)userId
{
    PFObject* parseInterest = [PFObject objectWithClassName:@"Interests"];
    
    [interests enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        parseInterest[key] = obj;
    }];
    
    [parseInterest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            //handle error
        }
    }];
}


/*
 * Add a user's location to parse (if not present), include the user's coordinates, id and the beacon
 * nearest their current location. The user's location is first checked to see if it 
 * exists in Parse already.
 * @ param CLLocation users current location
 * @ param NSString User Id the unique id of the user at the given location
 * @ param NSString uuid the unqiue id of the beacon the user
 * @ return void
 */
+(void)addLocation:(CLLocation*)location forUser:(NSString*)userId atBeacon:(NSString*)uuid
{
    
    PFQuery* query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"userId" equalTo:userId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count == 0)
        {
            NSNumber* latitude = [NSNumber numberWithDouble: location.coordinate.latitude];
            NSNumber* longitude = [NSNumber numberWithDouble: location.coordinate.longitude];
            
            PFObject* parseLocation = [PFObject objectWithClassName:@"Location"];
            
            parseLocation[@"userId"] = userId;
            parseLocation[@"uuid"] = uuid;
            parseLocation[@"latitude"] = latitude;
            parseLocation[@"longitude"] = longitude;
            parseLocation[@"locationTime"] = location.timestamp;
            
            [parseLocation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error)
                 {
                     //TODO: handle error on save
                     NSLog(@"error saving location");
                 }
             }];
        }
    }];
}



/*
 * Adds a newly found beacon to the database of beacon if it has not already present.
 * A new beacon is currentlt determined by the UUID of the beacon
 * @param NSString name the name of the beacon as determined by the bluetooth peripheral name
 * @param NSString uuid the uuid of the beacon that was found
 * @return void
 */
+(void)addBeaconWithName:(NSString*)name withUUID:(NSString*)uuid
{
    
    //convert the beacon object into a parse object
    
    
    PFObject* parseBeacon = [PFObject objectWithClassName:@"Beacon"];
    
    //if we have not see this beacon before add it to the list of beacons
    PFQuery *query = [PFQuery queryWithClassName:@"Beacon"];
    [query whereKey:@"uuid" equalTo:uuid];
    [query whereKey:@"name" equalTo:name];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         //first check if the beacon is in Parse, if not then add it
         if (objects.count == 0)
         {
             
             [parseBeacon saveEventually:^(BOOL succeeded, NSError *error)
              {
                  if (error)
                  {
                      //if the beacon is not added to parse
                  }
              }];
         }
     }];

}

/*
 * Convert a UIImage to a PFFile object to storage on parse
 * @param UIImage image the UIImage to be converted to a Parse file
 * @return PFFile file the file created from the UIImage object
 */
+(PFFile*)convertUIImageToPFFile:(UIImage*)image
{
    NSData* imagedata = UIImageJPEGRepresentation(image, 0.8f);
    PFFile* file = [PFFile fileWithData:imagedata];
    return file;
}

@end
