//
//  DoctorTableViewController.m
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "DoctorTableViewController.h"
#import "DateTableViewController.h"
#import "SBJson.h"

@implementation DoctorTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setDoctorsArray];
}

- (void) setDoctorsArray{
    
    
    // Create new SBJSON parser object
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    @try {
        
        NSArray* temp_Doctorset =@[@"Saberi",@"Nagmaeh"];
        
        
        // Prepare URL request to download statuses from Twitter
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://blooming-sea-6547.herokuapp.com/doctors_registry"]];
        
        // Perform request and get JSON back as a NSData object
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        //NSLog(@"response is %@",response);
        
        // Get JSON as a NSString from NSData response
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        //NSLog(@"json_string is %@",json_string);
        // parse the JSON response into an object
        // Here we're using NSArray since we're parsing an array of JSON status objects
        NSDictionary *doctorset = [parser objectWithString:json_string ];
        self.idoctor = [doctorset valueForKey:@"doctors"];
        //NSLog(@"itask is %@",ipatient );
        // Each element in statuses is a single status
        // represented as a NSDictionary
        
        NSString* doc_name = [[NSString alloc] init];
        NSString* temp_loc= [[NSString alloc] initWithFormat:@"%@",self.pat.location];
        NSString* temp_cat =[[NSString alloc] initWithFormat:@"%@",self.pat.category];
        
        NSLog(@"location is %@; category is %@ in doctors page",temp_loc,temp_cat);
        
        BOOL Success_found = NO;
        for (NSDictionary* each_doctor in self.idoctor)
        {
            NSLog(@"%@ is each doctor",each_doctor);
            
            if ([temp_loc isEqualToString:[each_doctor valueForKey:@"location"]]){
                if([temp_cat isEqualToString: [each_doctor valueForKey:@"category"]]){
                    
                    NSLog(@"Hi %@, Doctor found !!",self.pat.name);
                    Success_found = YES;
                    
                    doc_name = [each_doctor valueForKey:@"name"];
                    
                    temp_Doctorset = [temp_Doctorset arrayByAddingObject:doc_name];
                }
                
            }
        }
        if(Success_found == NO){
            NSLog(@"Doctor not found. Try different combination of Location and category");
         
        }
        
        self.doctors = temp_Doctorset;
        
    }
    @catch (NSException* e ) {
        
        NSLog(@"Exception raised : %@", [e reason]);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.doctors = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.doctors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    static NSString *MyIdentifier = @"doctorCellId";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    NSString *doctor = [self.doctors objectAtIndex: indexPath.row];
    cell.textLabel.text = doctor;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.pat.category];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tap!");
    //[self performSegueWithIdentifier:@"detailsegue" sender:self];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
   
    
}

//----------------------------------------------------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"doctorsToDates"]){
        DateTableViewController* detailVC = segue.destinationViewController;
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NSString* temp_doc1 = [self.doctors objectAtIndex:selectedRowIndex.row];
        NSLog(@"temp_doc1 at prepare segue in doc_vc is %@",temp_doc1);
        NSString* datesStr = [[NSString alloc] init];
        NSArray* dateArray = [[NSArray alloc] init];
        
        
        NSString* d_id ;
        for (NSDictionary* each_doctor in self.idoctor)
        {
            NSLog(@"%@ is each doctor",each_doctor);
            
            if ([ temp_doc1 isEqualToString:[each_doctor valueForKey:@"name"]]){
              
                    
                NSLog(@"Hi %@, Doctor found !!",self.pat.name);
                datesStr = [each_doctor valueForKey:@"available_dates"];
                dateArray = [datesStr componentsSeparatedByString:@";"];
                NSLog(@"%@ is date ARRAy" ,dateArray);
                
                d_id = [[NSString alloc] initWithFormat:@"%@",[each_doctor valueForKey:@"id"]];
                
                NSLog(@"%@",d_id);
                
            }
            
            
        }
        
        detailVC.dates = dateArray;
        
        
        NSLog(@"Combined string is %@", datesStr);
        
        [detailVC setPatient_obj:self.pat setDoctor_id:d_id];
    }
}


- (void) setPatient_obj:(patient*) p1
{
    NSLog(@"Inside set patient object method");
    self.pat = [[patient alloc] init];
    self.pat.p_id = [p1 p_id];
    self.pat.name = [p1 name];
    self.pat.category = [p1 category];
    self.pat.location = [p1 location];
    
    NSLog(@"passed patient id is :%@", self.pat.p_id);
    
    
}


@end
