//
//  Category.m
//  EKEventToiCal
//
//  Created by Dan Willoughby on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EKEvent+Utilities.h"
@implementation EKEvent (Utilities)




-(NSString *) genRandStringLength {
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int len = 36;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex:(rand() % [letters length])]];

         }
    
    NSString *c = [randomString substringWithRange:NSMakeRange(0, 8)];
    NSString *d = [randomString substringWithRange:NSMakeRange(8, 4)];
    NSString *e = [randomString substringWithRange:NSMakeRange(12, 4)];
    NSString *f = [randomString substringWithRange:NSMakeRange(16, 4)];
    NSString *g = [randomString substringWithRange:NSMakeRange(20, 12)];
    
    NSMutableString *stringWithDashes = [NSMutableString string];

    [stringWithDashes appendFormat:@"%@-%@-%@-%@-%@",c,d,e,f,g];
    
    return stringWithDashes;
}
         
- (NSMutableString *)iCalString {
    


    NSMutableString *iCalString = [NSMutableString string];

    
    //The first line must be "BEGIN:VCALENDAR"
    [iCalString appendString:@"BEGIN:VCALENDAR"];
    [iCalString appendString:@"\r\nVERSION:2.0"];


     
    //calendar
     
    if (self.calendar.title) {
    //[iCalString appendFormat:@"\r\nX-WR-CALNAME:%@",self.calendar.title];
    }
    
    
    //  CGColorRef blah = self.calendar.CGColor;
    // NSLog(@"********************* = %@",blah);
    
    
    //X-WR-CALNAME:Untitled 2 -----calendar's Title ical
    //X-APPLE-CALENDAR-COLOR:#F57802 -----calendar color ical
    


  

//Event Start Date
    [iCalString appendString:@"\r\nBEGIN:VEVENT"];

      //allDay
    if (self.allDay) {
        
        NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
        [format1 setDateFormat:@"yyyyMMdd"];
        NSString *allDayDate = [format1 stringFromDate:self.startDate];

        [iCalString appendFormat:@"\r\nDTSTART;VALUE=DATE:%@",allDayDate];
        
        //get startdate and add 1 day for the end date.
        NSDate *addDay = [self.startDate dateByAddingTimeInterval:86400];
        NSString *allDayEnd = [format1 stringFromDate:addDay];

        [iCalString appendFormat:@"\r\nDTEND;VALUE=DATE:%@",allDayEnd];
        [format1 release];

        
    }
    
    else {
        
        if (self.startDate && self.endDate) {
            [iCalString appendString:@"\r\nDTSTART;TZID=America/Denver:"];
            
            NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
            [format2 setDateFormat:@"yyyyMMdd'T'HHmmss"];
            
            NSString *dateAsString = [format2 stringFromDate:self.startDate];
            [iCalString appendString:dateAsString];
        //end date
   
            [iCalString appendString:@"\r\nDTEND;TZID=America/Denver:"];
            
            NSString *dateAsString1 = [format2 stringFromDate:self.endDate];
            
            [iCalString appendString:dateAsString1];
            
            [format2 release];
            
        }
        else {
            NSLog(@"****Error****Missing one of needed values: startDate or endDate");
        }
    }   
    
    [iCalString appendString:@"\r\nDTSTAMP:"];    //date the event was created
    NSDateFormatter *format3 = [[NSDateFormatter alloc] init];
    [format3 setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    
    NSString *dateAsString2 = [format3 stringFromDate:self.lastModifiedDate];
    [iCalString appendString:dateAsString2];
    
    //lastModifiedDate
    if (self.lastModifiedDate) {
        
        [iCalString appendString:@"\r\nLAST-MODIFIED:"];
        
        NSString *dateAsString2 = [format3 stringFromDate:self.lastModifiedDate];
        [iCalString appendString:dateAsString2];
        
    }
    [format3 release];
    //UID is generated randomly
    NSString *a = [self genRandStringLength];
    [iCalString appendFormat:@"\r\nUID:%@0000000000000000000",a];
  
    
    
    //attendees @TODO: The property is read-only and cannot be modified so this is not complete or tested
    
    for (EKParticipant *attend in self.attendees) {
        [iCalString appendString:@"\r\nATTENDEE"];
        if (attend.name) {
            [iCalString appendFormat:@";CN=%@",attend.name];
        }
        //@TODO:this is not complete
        if (attend.participantStatus) {
            [iCalString appendFormat:@";PARTSTAT=%@",attend.participantStatus];
        }
         //@TODO:this is not complete
        if (attend.participantType) {
            
            [iCalString appendFormat:@";CUTYPE=%@",attend.participantType];
        }
        //@TODO:this is not complete
        if (attend.participantRole) {
            [iCalString appendFormat:@";ROLE=%@",attend.participantRole];
        }
    }
        
    //ATTENDEE;CN="Dan Willoughby";CUTYPE=INDIVIDUAL;PARTSTAT=ACCEPTED:mailto:email
    //availability @TODO:    The property is read-only and cannot be modified so this is not complete or tested

    if (self.availability == 1) {
        [iCalString appendString:@"\r\nTRANSP:OPAQUE"];    //busy
    }
    else {
        [iCalString appendString:@"\r\nTRANSP:TRANSPARENT"];    //free
    }
    NSLog(@" %d",self.availability);
    //eventIdentifier @TODO: The property is read-only and cannot be modified so this is not complete or tested
    
    //isDetached @TODO: The property is read-only and cannot be modified so this is not complete or tested
    
    //location
    if (self.location) {
        [iCalString appendFormat:@"\r\nLOCATION:%@",self.location];
    }
    
    //organizer @TODO: The property is read-only and cannot be modified so this is not complete or tested
    if  (self.organizer != nil) {
        [iCalString appendString:@"\r\nORGANIZER"];
        if (self.organizer.name) {
            [iCalString appendFormat:@";CN=%@",self.organizer.name];
        }
        //this is not complete
        if (self.organizer.participantStatus) {
            [iCalString appendFormat:@";PARTSTAT=%@",self.organizer.participantStatus];
            
        }
        //this is not complete
        if (self.organizer.participantType) {
            [iCalString appendFormat:@";CUTYPE=%@",self.organizer.participantType];
            
        }
        //this is not complete
        if (self.organizer.participantRole) {
            [iCalString appendFormat:@";ROLE=%@",self.organizer.participantRole];
            
        }
    }
    
    //recurrenceRule
    NSString *recurrenceString = [NSString stringWithFormat:@"%@", self.recurrenceRule];
    NSArray *partsArray = [recurrenceString componentsSeparatedByString:@"RRULE "];
    
    if ([partsArray count] > 1) {
        NSString *secondHalf = [partsArray objectAtIndex:1];
        // int loc = [secondHalf rangeOfString:@"Z"].location;
        //if (loc > 0) {
        //   return [secondHalf substringToIndex:loc];
        [iCalString appendFormat:@"\r\nRRULE:%@",secondHalf];
    }
    
    //When a calendar component is created, its sequence number is zero 
    [iCalString appendString:@"\r\nSEQUENCE:0"];
    
    //status
    if (self.status == 1) {
        [iCalString appendString:@"\r\nSTATUS:CONFIRMED"];
    }
    if (self.status == 2) {
        [iCalString appendString:@"\r\nSTATUS:TENTATIVE"];
    }
    if (self.status == 3) {
        [iCalString appendString:@"\r\nSTATUS:CANCELLED"];
    }
    
    //Event Title
    if (self.title) {
        [iCalString appendFormat:@"\r\nSUMMARY:%@",self.title];
    }
    
    //Notes
    if (self.notes) {
        [iCalString appendFormat:@"\r\nDESCRIPTION:%@",self.notes];
    }
    
    //Alarm
    for (EKAlarm *alarm in self.alarms) {
        [iCalString appendString:@"\r\nBEGIN:VALARM"];
        [iCalString appendString:@"\r\nACTION:DISPLAY"];//a message(usually the title of the event) will be displayed
        [iCalString appendString:@"\r\nDESCRIPTION:event reminder"]; //notes with the alarm--not the message.

        if (alarm.absoluteDate) {
           
            NSDateFormatter *format3 = [[NSDateFormatter alloc] init];
            [format3 setDateFormat:@"yyyyMMdd'T'HHmmss"];
            
            NSString *dateAsString3 = [format3 stringFromDate:alarm.absoluteDate];
            [format3 release];
            
            [iCalString appendFormat:@"\r\nTRIGGER;VALUE=DATE-TIME:%@",dateAsString3];

        }
        if (alarm.relativeOffset) {
            
            //converts offset to D H M S then appends it to iCalString
            NSInteger offset = alarm.relativeOffset;
            int i = offset * - 1;
            
            int day = i / (24*60*60);
            i = i % (24*60*60);
            
            int hour = i / (60*60);
            i = i % (60*60);
            
            int minute = i / 60;
            i = i % 60;
            
            int second = i;
            
            [iCalString appendFormat:@"\r\nTRIGGER:-P"];
            
            if (day != 0) {
                
                [iCalString appendFormat:@"%dD", day];
                
            }
            if (hour || minute || second != 0) {
                [iCalString appendString:@"T"];
                
                if (hour != 0) {
                    
                    [iCalString appendFormat:@"%dH", hour];
                    
                }
                if (minute != 0) {
                    
                    [iCalString appendFormat:@"%dM", minute];
                    
                }
                if (second != 0) {
                    
                    [iCalString appendFormat:@"%dS", second];
                    
                }
            }
        }
        NSString *b = [self genRandStringLength];
 
        [iCalString appendFormat:@"\r\nX-WR-ALARMUID:%@",b];

        [iCalString appendString:@"\r\nEND:VALARM"];

    }
        
    [iCalString appendString:@"\r\nEND:VEVENT"];
    
    //The last line must be "END:VCALENDAR"
    [iCalString appendString:@"\r\nEND:VCALENDAR"];
    
    return iCalString;
}

  



@end
