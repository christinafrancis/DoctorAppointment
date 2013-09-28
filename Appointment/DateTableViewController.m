//
//  DateTableViewController.m
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

//
//  DoctorTableViewController.m
//  Appointment
//
//  Created by Christina Francis on 9/27/13.
//  Copyright (c) 2013 Christina Francis. All rights reserved.
//

#import "DateTableViewController.h"
#import "SBJson.h"
#import "ConfirmViewController.h"

@implementation DateTableViewController


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

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.dates = nil;
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
    return [self.dates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    static NSString *MyIdentifier = @"dateCellId";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    NSString *date = [self.dates objectAtIndex: indexPath.row];
    cell.textLabel.text = date;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", date];
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
        
        if ([segue.identifier isEqualToString:@"datesToConfirm"]){
            ConfirmViewController* detailVC = segue.destinationViewController;
            NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
            NSString* temp_dat1 = [self.dates objectAtIndex:selectedRowIndex.row];
            NSLog(@"temp_dat1 at prepare segue in doc_vc is %@",temp_dat1);
            NSString* datesStr = [[NSString alloc] init];
            NSArray* dateArray = [[NSArray alloc] init];
            NSString* d_id ;
            
            //parse through dateArray, remove the selected date to store in doctor_registry - available_dates
            
            for( NSString* d in self.dates){
                
                if (![d isEqualToString:temp_dat1]){
                    
                    dateArray = [dateArray arrayByAddingObject:d];
                }
                
            }
            
            
            datesStr = [dateArray componentsJoinedByString:@";"];
            detailVC.available_dates = datesStr;
            
            [detailVC setPatient_obj:self.pat setDoctor_id:d_id setDate:temp_dat1];
        }
    

}


- (void) setPatient_obj:(patient*) p1 setDoctor_id:(NSString*)d_id
{
    NSLog(@"Inside set patient object method");
    self.pat = [[patient alloc] init];
    self.pat.p_id = [p1 p_id];
    self.pat.name = [p1 name];
    self.pat.category = [p1 category];
    self.pat.location = [p1 location];
    
    NSLog(@"passed patient id is :%@", self.pat.p_id);
    
    self.doctor_id = d_id;
    
    NSLog(@"%@ is doctor_id at dates page",self.doctor_id);
    
    
}


@end
