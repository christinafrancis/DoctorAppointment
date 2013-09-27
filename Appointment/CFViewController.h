//
//  CFViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/23/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_uname;
@property (weak, nonatomic) IBOutlet UITextField *tf_pswd;
@property (weak, nonatomic) UITextField *activeTF;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@end
