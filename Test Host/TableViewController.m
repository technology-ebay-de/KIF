//
//  TableViewController.m
//  KIF
//
//  Created by Hilton Campbell on 4/12/14.
//
//

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Need to set this explicitly, as the default is different between iPhone and iPad and the value is ignored if set explicitly to "none"
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Do nothing, this method is needed to activate reordering in edit mode
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

// Work around a bug on iOS9 that accessibility trait Selected doesn't get set
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedSame) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessibilityTraits:cell.accessibilityTraits | UIAccessibilityTraitSelected];
    }

    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedSame) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessibilityTraits:cell.accessibilityTraits ^ UIAccessibilityTraitSelected];
    }
    
    return indexPath;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Since the table view uses static cells, it is not possible to remove the row,
        // so let's just change the label to have something to check in unit tests
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"Deleted";
        [self.tableView setEditing:NO animated:YES];
        
        // NOTE: These don't work very well
        // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // [self.tableView reloadData];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 3;
        case 1: return 38;
        case 2: return 2;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return [self tableView:tableView defaultCellForRowAtIndexPath:indexPath text:@"First Cell"];
                case 1:
                    return [tableView dequeueReusableCellWithIdentifier:@"Switch" forIndexPath:indexPath];
                case 2:
                    return [tableView dequeueReusableCellWithIdentifier:@"TextField" forIndexPath:indexPath];
            }
        }
        case 1:
            return [self tableView:tableView defaultCellForRowAtIndexPath:indexPath text:[NSString stringWithFormat:@"Cell %zd", indexPath.row]];
        case 2: {
            switch (indexPath.row) {
                case 0:
                    return [tableView dequeueReusableCellWithIdentifier:@"Button" forIndexPath:indexPath];
                case 1:
                    return [self tableView:tableView defaultCellForRowAtIndexPath:indexPath text:@"Last Cell"];
            }
        }
    }

    return nil; // Shouldn't get here at all.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section-%zd", section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView defaultCellForRowAtIndexPath:(NSIndexPath *)indexPath text:(NSString *)text
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Default" forIndexPath:indexPath];
    cell.textLabel.text = text;
    return cell;
}

@end
