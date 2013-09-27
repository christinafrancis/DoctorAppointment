//
//  SignUpViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/25/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patient.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_uname;
@property (weak, nonatomic) IBOutlet UITextField *tf_pswd;
@property (weak, nonatomic) IBOutlet UITextField *tf_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_status;


@property (weak, nonatomic) UITextField *activeTF;


- (void) setPatient_obj:(patient*) p1;

@end
