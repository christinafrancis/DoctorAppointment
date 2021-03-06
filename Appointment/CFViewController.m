//
//  CFViewController.m
//  Appointment
//
//  Created by Christina Francis on 9/23/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "CFViewController.h"
#import "SBJson.h"
#import "UITextField+nextTextField.h"
#import "patient.h"
#import "SignUpViewController.h"


@interface CFViewController ()

@property patient* pat1;

- (IBAction)handleSignIn:(id)sender;
- (IBAction)handleSignUp:(id)sender;

@end

@implementation CFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tf_uname.nextTextField = self.tf_pswd;
    self.tf_pswd.nextTextField = self.tf_uname;
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
        if ([self.tf_uname isFirstResponder]) {
            [self.tf_uname resignFirstResponder];
        }
        if ([self.tf_pswd isFirstResponder]) {
            [self.tf_pswd resignFirstResponder];
        }
    }
}

- (void)nextOrPreviousClicked: (UIBarButtonItem*) sender
{
    UITextField* next = self.activeTF.nextTextField;
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
    self.lb_status.text =@" ";
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Previous"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(nextOrPreviousClicked:)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Next"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(nextOrPreviousClicked:)];
    
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



- (IBAction)handleSignIn:(id)sender {
    [self patient_gethttp:sender];
    
}



- (IBAction)handleSignUp:(id)sender {
    
    NSLog(@" inside cfViewcont handle sign up");
        [self performSegueWithIdentifier:@"mainToSignUp" sender:sender];
    NSLog(@"End of handle sign up");
    }
    
    // This will get called too before the view appears
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
        
        NSLog(@" inside cfViewcont prerare for segue");

        if ([[segue identifier] isEqualToString:@"mainToSignUp"] || [[segue identifier] isEqualToString:@"mainToUserPage"]) {
            
            // Get destination view
            SignUpViewController *vc = [segue destinationViewController];
          
            
            // Pass the information to your destination view
            [vc setPatient_obj:self.pat1];
            
            NSLog(@"End of prepare for segue..");
        }
    }



- (void)patient_gethttp:(id)sender
{
    self.pat1 =[[patient alloc] init];
    
    // Create new SBJSON parser object
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    @try {
        
        
        // Prepare URL request to download statuses from Twitter
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://blooming-sea-6547.herokuapp.com/patients_registry"]];
        
        // Perform request and get JSON back as a NSData object
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        //NSLog(@"response is %@",response);
        
        // Get JSON as a NSString from NSData response
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        //NSLog(@"json_string is %@",json_string);
        // parse the JSON response into an object
        // Here we're using NSArray since we're parsing an array of JSON status objects
        NSDictionary *patientset = [parser objectWithString:json_string ];
        NSArray* ipatient = [patientset valueForKey:@"patients"];
        //NSLog(@"itask is %@",ipatient );
        // Each element in statuses is a single status
        // represented as a NSDictionary
        
        BOOL Success_signin = NO;
        for (NSDictionary* each_patient in ipatient)
        {
            
            NSString* temp_uname= [[NSString alloc] initWithFormat:@"%@",[self.tf_uname text]];
            NSString* temp_pswd =[[NSString alloc] initWithFormat:@"%@",[self.tf_pswd text]];
            
            if ([temp_uname  isEqualToString:[each_patient valueForKey:@"username"]]){
                if([temp_pswd isEqualToString: [each_patient valueForKey:@"password"]]){
                    
                    self.pat1.p_id = [each_patient valueForKey:@"id"];
                    self.pat1.name = [each_patient valueForKey:@"name"];
                    NSLog(@"Hi %@, You have successfully signed in !!",self.pat1.name);
                    Success_signin = YES;
                    [self performSegueWithIdentifier:@"mainToUserPage" sender:sender];
                    
                }
                
            }
        }
        if(Success_signin == NO){
            NSLog(@"Wrong password or username");
            self.lb_status.text =@"Wrong password or username";
        }
        
    }
    @catch (NSException* e ) {
        
        NSLog(@"Exception raised : %@", [e reason]);
    }
}




// below methods are unused. Just for learning/referencing purpose...
- (void)patient_posthttp
{
    NSString* webserviceURLStr = @"http://blooming-sea-6547.herokuapp.com";
    NSString* returnStr = [[NSString alloc] init];
    NSString* inputStr = @"{\"title\":\"Read something new\"}";
    
    NSLog(@"Trying to connect %@ ...", webserviceURLStr);
    
    int responseCode=500;
    
    @try
    {
        returnStr = @"ERROR: Connection to the Webservice could not be established";
        NSURL* url = [NSURL URLWithString:webserviceURLStr];
        NSMutableURLRequest* urlRequest=[NSMutableURLRequest requestWithURL:url];
        if (inputStr != nil)
        {
            [urlRequest setHTTPMethod:@"POST"];
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


- (void)doctor_gethttp
{
    // Create new SBJSON parser object
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    @try {
        
        
        // Prepare URL request to download statuses from Twitter
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://blooming-sea-6547.herokuapp.com"]];
        
        // Perform request and get JSON back as a NSData object
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSLog(@"response is %@",response);
        
        // Get JSON as a NSString from NSData response
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        NSLog(@"json_string is %@",json_string);
        // parse the JSON response into an object
        // Here we're using NSArray since we're parsing an array of JSON status objects
        NSDictionary *statuses = [parser objectWithString:json_string ];
        NSArray* itask = [statuses valueForKey:@"tasks"];
        NSLog(@"itask is %@",itask );
        // Each element in statuses is a single status
        // represented as a NSDictionary
        for (NSDictionary* each_task in itask)
        {
            NSLog(@"%@ is status", each_task);
            // You can retrieve individual values using objectForKey on the status NSDictionary
            // This will print the tweet and username to the console
            NSLog(@"%@ - %@", [each_task valueForKey:@"title"], [each_task valueForKey:@"id"] );
        }
        
    }
    @catch (NSException* e ) {
        
        NSLog(@"Exception raised : %@", [e reason]);
    }
}


@end
