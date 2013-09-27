//
//  UserPageViewController.m
//  Appointment
//
//  Created by Christina Francis on 9/26/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "UserPageViewController.h"
#import "SBJson.h"
#import "UITextField+nextTextField.h"
#import "patient.h"


@interface UserPageViewController ()

@property patient* pat;

- (IBAction)hanlde_findDoctor:(id)sender;


@end

@implementation UserPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Sign up view loaded successfully...");
    NSString *titleStr = [[NSString alloc] initWithFormat:@"Hello %@, Welcome to User Page",self.pat.name];
    [self.lb_title setText:titleStr] ;
    
    self.tf_loc.nextTextField = self.tf_cat;
    self.tf_cat.nextTextField = self.tf_loc;
    
    self.tf_loc.prevTextField = self.tf_cat;
    self.tf_cat.prevTextField = self.tf_loc;
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog( @"resigning first respond for inputTextField; Touch event!" );
    if ( ! [self isFirstResponder]) {
        if ([self.tf_loc isFirstResponder]) {
            [self.tf_loc resignFirstResponder];
        }
        if ([self.tf_cat isFirstResponder]) {
            [self.tf_cat resignFirstResponder];
        }
    }
}

- (void)nextClicked: (UIBarButtonItem*) sender
{
    UITextField* next = self.activeTF.nextTextField;
    if (next) {
        [next becomeFirstResponder];
    }
}

- (void)previousClicked: (UIBarButtonItem*) sender
{
    UITextField* next = self.activeTF.prevTextField;
    if (next) {
        [next becomeFirstResponder];
    }
}

- (void) doneClicked: (UIBarButtonItem*) sender
{
    NSLog( @"done pressed resigning first respond for inputTextField; Touch event!" );
    [self.activeTF resignFirstResponder];
}



- (BOOL)textFieldShouldBeginEditing: (UITextField *) textField
{
    self.activeTF = textField;
    NSLog(@"Right before");
    
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Previous"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(previousClicked:)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Next"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(nextClicked:)];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                   target: self
                                   action: nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                  target: self
                                  action: @selector(doneClicked:)];
    
    NSArray* itemsArray = @[prevButton, nextButton, flexButton, doneButton];
    
    [toolbar setItems: itemsArray];
    
    [textField setInputAccessoryView: toolbar];
    
    return YES;
}


- (void) setPatient_obj:(patient*) p1
{
    NSLog(@"Inside set patient object method");
    self.pat = [[patient alloc] init];
    self.pat.p_id = [p1 p_id];
    self.pat.name = [p1 name];
    NSLog(@"passed patient id is :%@", self.pat.p_id);
  
    
}

- (IBAction)hanlde_findDoctor:(id)sender {
    [self patient_puthttp];
}


- (void) patient_puthttp{
    
    NSString* inputStr = [[NSString alloc] initWithFormat:@"{\"location\":\"%@\",\"category\":\"%@\"}",[self.tf_loc text],  [self.tf_cat text]];
    
    //location is not a key in patients regitstry.. only used in finding doctor...
    
    NSString* webserviceURLStr = [[NSString alloc] initWithFormat:@"http://blooming-sea-6547.herokuapp.com/patients_registry/%@",self.pat.p_id];
    
    NSString* returnStr = [[NSString alloc] init];
    
    // Create new SBJSON parser object
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSLog(@"Trying to connect %@ ...", webserviceURLStr);
    
    int responseCode=500;
    
    @try
    {
        returnStr = @"ERROR: Connection to the Webservice could not be established";
        NSURL* url = [NSURL URLWithString:webserviceURLStr];
        NSMutableURLRequest* urlRequest=[NSMutableURLRequest requestWithURL:url];
        if (inputStr != nil)
        {
            [urlRequest setHTTPMethod:@"PUT"];
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
            [urlRequest setHTTPBody:[inputStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        NSURLResponse* response;
        NSError* error;
        NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        if (result == nil)
        {
            NSLog(@"Connection to Webservice %@ could not be established", webserviceURLStr);
            NSLog(@"%d",responseCode);
        }
        
        if ((response != nil))
        {
            responseCode =  [(NSHTTPURLResponse*) response statusCode];
            NSLog(@"HTTP response code is %i", responseCode);
            if (responseCode == 200)
            {
                returnStr =  [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] ;
                
                
                
                
                
                if (returnStr != nil)
                {
                    if ([returnStr length] == 0)
                    {
                        returnStr = @"ERROR: No data received from the Webservice";
                        NSLog(@"No data received from the server");
                    }
                    else
                    {
                        // parse the JSON response into an object
                        // Here we're using NSArray since we're parsing an array of JSON status objects
                        
                        NSDictionary *patientset = [parser objectWithString:returnStr ];
                        
                        NSDictionary* ipatient = [patientset valueForKey:@"patient"];
                        
                        NSLog(@"%@",ipatient);
                        // There is going to be just 1 element in the dictionary array
            
                       
                    }
                    
                    
                }
                else
                {
                    returnStr = @"ERROR: No data received from the Webservice";
                    NSLog(@"No data received from the Webservice");
                }
            }
            else
            {
                responseCode = 500;
                NSLog(@"Remote url returned error %@",[NSHTTPURLResponse localizedStringForStatusCode:responseCode]);
            }
        }
        else
        {
            NSLog(@"Error in connecting to Webservice %@.", webserviceURLStr);
            NSLog(@"%d", responseCode);
        }
    } @catch (NSException* e ) {
        responseCode = 500;
        returnStr = @"ERROR: Exception occured while connecting to the Webservice";
        NSLog(@"Exception raised : %@", [e reason]);
    }
    NSLog(@"%d", responseCode);
}


@end