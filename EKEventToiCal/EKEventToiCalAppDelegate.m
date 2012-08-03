//
//  EKEventToiCalAppDelegate.m
//  EKEventToiCal
//
//  Created by Dan Willoughby on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EKEventToiCalAppDelegate.h"
#import "EKEvent+Utilities.h"
#import <EventKit/EventKit.h>

@implementation EKEventToiCalAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    EKEventStore *store = [[EKEventStore alloc] init];
    //EKEvent *newEvent = [EKEvent eventWithEventStore:store];
    // Create the predicate's start and end dates.
    CFGregorianDate gregorianStartDate, gregorianEndDate;
    CFGregorianUnits startUnits = {0, 0, -365, 0, 0, 0};
    CFGregorianUnits endUnits = {0, 0, 365, 0, 0, 0};
    CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
    
    gregorianStartDate = CFAbsoluteTimeGetGregorianDate(
                                                        CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, startUnits),
                                                        timeZone);
    gregorianStartDate.hour = 0;
    gregorianStartDate.minute = 0;
    gregorianStartDate.second = 0;
    
    gregorianEndDate = CFAbsoluteTimeGetGregorianDate(
                                                      CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, endUnits),
                                                      timeZone);
    gregorianEndDate.hour = 0;
    gregorianEndDate.minute = 0;
    gregorianEndDate.second = 0;
    
    NSDate* startDate =
    [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianStartDate, timeZone)];
    NSDate* endDate =
    [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianEndDate, timeZone)];
    
    CFRelease(timeZone);
    
    // Create the predicate.
    NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil]; // eventStore is an instance variable.
    
    // Fetch all events that match the predicate.
    NSArray *events = [store eventsMatchingPredicate:predicate];
    NSLog(@"%@",events);
    

    /*
    newEvent.title = @"A new event";
    newEvent.startDate = [NSDate date];
    newEvent.endDate = [[NSDate alloc] initWithTimeInterval:40000000 sinceDate:newEvent.startDate];
     */
    
    NSString *icalRepresentation = [NSString string];

    NSMutableString *ical = [NSMutableString string];
    for (EKEvent *event in events) {
        icalRepresentation = [event iCalString]; 

        [ical appendString:icalRepresentation];
      
    }
    NSLog(ical);
    [ical writeToFile:@"myfile.ics" atomically:NO encoding:NSUTF8StringEncoding error: nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
