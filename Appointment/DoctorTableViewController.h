//
//  DoctorTableViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "patient.h"

@interface DoctorTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain) NSArray* doctors;
@property patient* pat;
@property  NSArray*  idoctor;

- (void) setPatient_obj:(patient*) p1;

@end