//
//  SignUpViewController.h
//  Appointment
//
//  Created by Christina Francis on 9/23/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//



#import "SignUpViewController.h"
#import "SBJson.h"
#import "UITextField+nextTextField.h"
#import "patient.h"
#import "UserPageViewController.h"


@interface SignUpViewController ()

@property patient* pat;

- (IBAction)handle_SubmitSignUp:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Sign up view loaded successfully...");
	// Do any additional setup after loading the view, typically from a nib.
    self.tf_uname.nextTextField = self.tf_pswd;
    self.tf_pswd.nextTextField = self.tf_name;
    self.tf_name.nextTextField = self.tf_uname;
    
    self.tf_uname.prevTextField = self.tf_name;
    self.tf_pswd.prevTextField = self.tf_uname;
    self.tf_name.prevTextField = self.tf_pswd;
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
    if ([self.tf_name isFirstResponder]) {
        [self.tf_name resignFirstResponder];
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
    
    //[self.lb_status isHidden:YES];
    
    self.lb_status.text = @"  ";
    
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
patient *pat1 = [[patient alloc] init];
    pat1.p_id = [p1 p_id];
    NSLog(@"passed patient id is :%@", pat1.p_id);
}

- (IBAction)handle_SubmitSignUp:(id)sender {
    
    [self patient_gethttp: sender];
}


- (void)patient_gethttp:(id) sender
{
    
    
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
        
        BOOL Success_matchFound = NO;
        for (NSDictionary* each_patient in ipatient)
        {
            
            NSString* temp_uname= [[NSString alloc] initWithFormat:@"%@",[self.tf_uname text]];
            NSString* temp_pswd =[[NSString alloc] initWithFormat:@"%@",[self.tf_pswd text]];
            NSString* temp_name = [[NSString alloc] initWithFormat:@"%@",[self.tf_name text]];
            if([temp_uname length] == 0 || [temp_pswd length] == 0 || [temp_name length] == 0){
                NSLog(@"Enter all the compulsory fields marked *");
                self.lb_status.text = @"Enter all the compulsory fields marked *";
            }
        
            if ([temp_uname  isEqualToString:[each_patient valueForKey:@"username"]]){
                
                Success_matchFound = YES;
                NSLog(@"Existing username. Try again.");
                self.lb_status.text = @"Existing username. Try again.";
            }
        }
        if(Success_matchFound == NO){
            [self patient_posthttp:sender];
            NSLog(@"Signed up successfully");
        }
        
    }
    @catch (NSException* e ) {
        
        NSLog(@"Exception raised : %@", [e reason]);
    }
}


- (void)patient_posthttp: (id) sender
{
    
    
    NSString* inputStr1 = [[NSString alloc] initWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\",\"name\":\"%@\"}",[self.tf_uname text], [self.tf_pswd text], [self.tf_name text]];
    
//      NSLog(@"inputStr1 is %@",inputStr1);

    [self handle_postService:inputStr1 Sender:sender];
    
    
}

- (void) handle_postService:(NSString*) inputStr Sender:(id)sender{
    
    NSString* webserviceURLStr = @"http://blooming-sea-6547.herokuapp.com/patients_registry";
    NSString* returnStr = [[NSString alloc] init];
    self.pat = [[patient alloc] init];
    
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
            if (responseCode == 201)
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
                        
                        // There is going to be just 1 element in the dictionary array
                        
                        self.pat.p_id = [ipatient valueForKey:@"id"];
                        self.pat.name = [ipatient valueForKey:@"name"];
                        NSLog(@"Hi %@, You have successfully signed in !!",self.pat.name);
                        NSLog(@" inside cfViewcont handle sign up");
                        [self performSegueWithIdentifier:@"signUpToUserPage" sender:sender];
                        NSLog(@"End of handle sign up");
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

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@" inside cfViewcont prerare for segue");
    
    if ([[segue identifier] isEqualToString:@"signUpToUserPage"] ) {
        
        // Get destination view
        UserPageViewController *vc = [segue destinationViewController];
        
        
        // Pass the information to your destination view
        [vc setPatient_obj:self.pat];
        
        NSLog(@"End of prepare for segue..");
    }
}

@end
