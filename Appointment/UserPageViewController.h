//
//  UserPageViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/26/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patient.h"

@interface UserPageViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UITextField *tf_loc;

@property (weak, nonatomic) IBOutlet UITextField *tf_cat;

@property (weak, nonatomic) UITextField *activeTF;


- (void) setPatient_obj:(patient*) p1;

@end
