//
//  DateTableViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "patient.h"

@interface DateTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) NSArray* dates;
@property patient* pat;
@property  NSString*  doctor_id;

- (void) setPatient_obj:(patient*) p1 setDoctor_id:(NSString*)d_id;

@end