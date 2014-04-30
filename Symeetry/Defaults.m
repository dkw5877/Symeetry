//
//  Defaults.m
//  Symeetry
//
//  Created by Symeetry Team on 4/18/14.
//  Copyright (c) 2014 Symeetry Team. All rights reserved.
//

#import "Defaults.h"
@interface Defaults()

//redefine the properties so they can be set up in the class

@property (nonatomic, copy) NSUUID *defaultProximityUUID;
@property (nonatomic, copy) NSNumber *defaultPower;

@end

@implementation Defaults

NSString *BeaconIdentifier = @"com.Symeetry.beacon";

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
        NSUserDefaults* standardDefaults = [[NSUserDefaults alloc]init];
        
        if(![standardDefaults objectForKey:@"runOnce"])
        {
            [self resetToDefaultUUIDs];
            //update the user defaults to indicate that program has run
            NSDictionary* defaults = @{@"runOnce":@"YES"};
            [standardDefaults setObject:defaults forKey:@"runOnce"];
            [standardDefaults synchronize];
        }
        else if ([standardDefaults objectForKey:@"runOnce"])
        {
            [self loadProximityUUIDFromFile];
        }
        
        
//        // uuidgen should be used to generate UUIDs.
//        NSArray* temp = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
//                                     [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
//                                     [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"],
//                                         [[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"],
//                                         [[NSUUID alloc] initWithUUIDString:@"AFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"],
//                                         [[NSUUID alloc] initWithUUIDString:@"92AB49BE-4127-42F4-B532-90fAF1E26491"],
//                                         [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"],
//                                         [[NSUUID alloc] initWithUUIDString:@"08D4A950-80F0-4D42-A14B-D53E063516E6"],
//                                         [[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"],
//                                         [[NSUUID alloc] initWithUUIDString:@"C77581A3-D1C6-4648-A9AC-F8F85F361D54"],
//                                         [[NSUUID alloc] initWithUUIDString:@"8AEFB031-6C32-486F-825B-E26FA193487D"],
//                                         [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"]
//                                         ];
//
//        self.supportedProximityUUIDs = [NSMutableArray arrayWithArray:temp];
        
        self.defaultPower = @-59;
    }
    
    return self;
}


+ (Defaults *)sharedDefaults
{
    static id sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[self alloc] init];
    });
    
    return sharedDefaults;
}


- (NSUUID *)defaultProximityUUID
{
    return self.supportedProximityUUIDs[0];
}


- (void)saveUUIDListToFile
{
    //get the URL for the plist, and append a name for the plist
    NSURL *plist = [[self documentsDirectory]URLByAppendingPathComponent:@"proximityUUIDs.plist"];
    
    //wrtie the array contents to the file structure
    //[self.dictionary writeToURL:plist atomically:YES];
    
    //NSUUID ARE NOT SUPPROTED OBJECT TYPES FOR A PLIST!!!!
    
    NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (NSUUID* uuid in self.supportedProximityUUIDs)
    {
        [temp addObject:[uuid UUIDString]];
    }
    
    [temp writeToURL:plist atomically:YES];
    //create a user defaults object, and give it the date as a key
    // and note that it is last saved
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:@"last saved"];
    
    //sync the data
    [userDefaults synchronize];
    
    NSLog(@"data saved!");
    
}

- (void)loadProximityUUIDFromFile
{
    
    //get the url for the saved data
    NSURL* plist = [[self documentsDirectory]URLByAppendingPathComponent:@"proximityUUIDs.plist"];
    
    //load the array with the contents of the plist
    //self.dictionary = [NSDictionary dictionaryWithContentsOfURL:plist];
    NSArray *temp = [NSArray arrayWithContentsOfURL:plist];
    NSMutableArray* uuids = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (NSString* uuid in temp)
    {
        [uuids addObject:[[NSUUID alloc] initWithUUIDString:uuid]];
    }
    
    self.supportedProximityUUIDs = uuids;
    
    
}

- (void)resetToDefaultUUIDs
{
    NSArray* temp = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
                      [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
                      [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"],
                      [[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"],
                      [[NSUUID alloc] initWithUUIDString:@"AFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"],
                      [[NSUUID alloc] initWithUUIDString:@"92AB49BE-4127-42F4-B532-90fAF1E26491"],
                      [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"],
                      [[NSUUID alloc] initWithUUIDString:@"08D4A950-80F0-4D42-A14B-D53E063516E6"],
                      [[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"],
                      [[NSUUID alloc] initWithUUIDString:@"C77581A3-D1C6-4648-A9AC-F8F85F361D54"],
                      [[NSUUID alloc] initWithUUIDString:@"8AEFB031-6C32-486F-825B-E26FA193487D"],
                      [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"]
                      ];
    
    self.supportedProximityUUIDs = [NSMutableArray arrayWithArray:temp];
    [self saveUUIDListToFile];
}

-(NSURL*)documentsDirectory
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //find the directory for the application
    NSArray* directories = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    //return the directory, there should only be one
    return directories.firstObject;
}

@end
