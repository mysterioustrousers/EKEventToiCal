//
//  Category.h
//  EKEventToiCal
//
//  Created by Dan Willoughby on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EKEvent (Utilities)

 -(NSString *)genRandStringLength;


 -(NSMutableString*)iCalString;


@end
