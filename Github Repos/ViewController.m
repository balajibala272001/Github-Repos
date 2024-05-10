//
//  ViewController.m
//  Github Repos
//
//  Created by SG's Mac on 10/05/24.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchDataFromAPI];
    // Do any additional setup after loading the view.
}

- (void)fetchDataFromAPI {
    // Check if data is available in UserDefaults
    NSString *cachedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedData"];
    if (cachedData) {
        // Use cached data if available
        dispatch_async(dispatch_get_main_queue(), ^{
            self.apiLabel.text = cachedData;
        });
    }

    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/todos/2"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
        if (error == nil)
        {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError == nil) {
                NSString *title = jsonResponse[@"title"];
          

                // Save data to UserDefaults
                [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"cachedData"];
            

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.apiLabel.text = title;
                    
                });
            } else {
                NSLog(@"Error parsing JSON: %@", jsonError.localizedDescription);
            }
        } else {
            NSLog(@"Error fetching data: %@", error.localizedDescription);
        }
    }];

    [task resume];
}


@end
