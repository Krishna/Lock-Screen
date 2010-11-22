//
//  LCYDataBackedTableView.h
//

#import <UIKit/UIKit.h>

@interface LCYDataBackedTableView : UITableViewController 
{
	NSDictionary *dataToShow_;
}

- (void) loadTableDataFromPath: (NSString *) path;
- (void) setDataUsingDictionary: (NSDictionary *) dictionary;

- (NSString *) keyForSection:(int) section;
- (NSString *) keyForSectionTitle:(int) section; 
- (NSArray *) dataForIndexPath:  (NSIndexPath *) indexPath;
- (NSString *) cellTextForIndexPath: (NSIndexPath *) indexPath;
- (NSString *) selectorNameForIndexPath: (NSIndexPath *) indexPath;
- (UITableViewCellAccessoryType) cellAccessoryTypeForIndexPath: (NSIndexPath *) indexPath;
- (void) configureCell: (UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath;


@end
