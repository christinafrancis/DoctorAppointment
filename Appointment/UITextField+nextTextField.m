//
//  UITextField+nextTextField.m
//  Appointment
//
//  Created by Christina Francis on 9/25/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "UITextField+nextTextField.h"
#import <objc/runtime.h>

static Byte defaultHashKey1;
static Byte defaultHashKey2;

@implementation UITextField (NextPrevTextFieldProp)

-(UITextField*) nextTextField
{
    return objc_getAssociatedObject( self, &defaultHashKey1 );
}

-(void) setNextTextField: (UITextField *)nextTextField
{
    defaultHashKey1 += 1;
    
    objc_setAssociatedObject( self, &defaultHashKey1, nextTextField,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}


-(UITextField*) prevTextField
{
    return objc_getAssociatedObject( self, &defaultHashKey2 );
}

-(void) setPrevTextField: (UITextField *)prevTextField
{
    defaultHashKey2 += 1;
    
    objc_setAssociatedObject( self, &defaultHashKey2, prevTextField,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end