//
//  SettingsViewController.m
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2015/05/19.
//  Copyright (c) 2015年 Yuji Ogihara. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangeUserInfoViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *userGraduate;
@property (weak, nonatomic) IBOutlet UILabel *numberOfQuiz;
@property (weak, nonatomic) IBOutlet UISwitch *isAutoUpdate;

- (void)getUserDefaults ;

@property (nonatomic) NSInteger changeUserInfoKind ;

@end

enum {
    SECTION_USER_PRIFILE = 0,
    SECTION_GENERAL,
    SECTION_QUIZ,
    NUMBER_OF_SECTION
} ;

enum {
    ITEM_USER_NAME = 0,
    ITEM_USER_EMAIL,
    ITEM_USER_PASSWORD,
    NUMBER_OF_ROWS_IN_SECTION_USER
} ;

enum {
    ITEM_AUTO_UPDATE = 0,
    NUMBER_OF_ROWS_IN_SECTION_GENERAL
} ;

enum {
    ITEM_NUMBER_OF_QUIZ = 0 ,
    NUMBER_OF_ROWS_IN_SECTION_QUIZ
} ;

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser] ;
    self.userName.text = [user username] ;
    self.userEmail.text = [user email] ;
    self.userGraduate.text = [user objectForKey:@"graduate"] ;
    
    [self getUserDefaults] ;

}

- (IBAction)onChangeAutoUpdateSwitch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:self.isAutoUpdate.on forKey:@"auto_update"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return NUMBER_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case SECTION_USER_PRIFILE :
            return NUMBER_OF_ROWS_IN_SECTION_USER ;
            
        case SECTION_GENERAL:
            return NUMBER_OF_ROWS_IN_SECTION_GENERAL ;
            
        case SECTION_QUIZ :
            return NUMBER_OF_ROWS_IN_SECTION_QUIZ ;
            
        default:
            break;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section) {
/*
        case SECTION_USER_PRIFILE: {
            self.changeUserInfoKind = indexPath.row ;
            [self performSegueWithIdentifier:@"toChangeUserInfo" sender:self];            
        }
            break ;
 */
        case SECTION_QUIZ:
            switch (row) {
                case ITEM_NUMBER_OF_QUIZ:
                    // Tell prepareForSegue that distination is NOT ChangeUserInfo
                    self.changeUserInfoKind = -1 ;
                [self performSegueWithIdentifier:@"toSetNumberOfQuiz" sender:self];
                    break ;
                default:
                    break;
            }
        default:
            break;
    }
    [self.tableView reloadData];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (ITEM_USER_NAME <= self.changeUserInfoKind &&
        self.changeUserInfoKind < NUMBER_OF_ROWS_IN_SECTION_USER) {
        ChangeUserInfoViewController *secondViewController = segue.destinationViewController;
        secondViewController.kind = self.changeUserInfoKind;
    }
}

- (void)getUserDefaults{
    
    [NSUserDefaults resetStandardUserDefaults];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Set initial value
    NSDictionary *dict = @{
                           @"number_of_quiz" : @5,
                           @"auto_update" : @(YES)
                          };
    [defaults registerDefaults:dict];
    
    // # of Quiz
    NSInteger numberOfQuiz = [defaults integerForKey:@"number_of_quiz"];
    if (numberOfQuiz < 3 || 10 < numberOfQuiz) {
        numberOfQuiz = 5 ;
        [defaults setInteger:5 forKey:@"number_of_quiz"];
    }
    self.numberOfQuiz.text = [NSString stringWithFormat:@"%ld個", (long)numberOfQuiz] ;
    
    // Auto update
    BOOL isAutoUpdate = [defaults boolForKey:@"auto_update"];
    self.isAutoUpdate.on = isAutoUpdate ;
}

@end
