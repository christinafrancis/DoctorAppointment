//
//  UITextField+nextTextField.h
//  Appointment
//
//  Created by Christina Francis on 9/25/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UITextField (NextTextFieldProp)

@property (retain, nonatomic) UITextField* nextTextField;
@property (retain, nonatomic) UITextField* prevTextField;

@end

