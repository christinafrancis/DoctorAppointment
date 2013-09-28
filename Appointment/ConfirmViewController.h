//
//  ConfirmViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "patient.h"

@interface ConfirmViewController : UIViewController


@property NSString* n_date;
@property patient* pat;
@property NSString* available_dates;
@property  NSString*  doctor_id;

- (void) setPatient_obj:(patient*) p1 setDoctor_id:(NSString*)d_id setDate:(NSString*)n_date;

@end
