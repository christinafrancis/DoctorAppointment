//
//  ConfirmViewController.m
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "ConfirmViewController.h"

@implementation ConfirmViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@" Confirm view loaded successfully...dates_available is %@",self.available_dates);
	// Do any additional setup after loading the view, typically from a nib.
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setPatient_obj:(patient*) p1 setDoctor_id:(NSString*)d_id setDate:(NSString *)n_date
{
    NSLog(@"At confirm page, Inside set patient object method");
    self.pat = [[patient alloc] init];
    self.pat.p_id = [p1 p_id];
    self.pat.name = [p1 name];
    self.pat.category = [p1 category];
    self.pat.location = [p1 location];
    
    NSLog(@"At confirm page, passed patient id is :%@", self.pat.p_id);
    
    self.doctor_id = d_id;
    self.n_date = n_date;
    
    NSLog(@"%@ is doctor_id at confirm page",self.doctor_id);
    
    
}



@end
