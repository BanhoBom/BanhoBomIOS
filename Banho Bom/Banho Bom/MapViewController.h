//
//  MapViewController.h
//  Banho Bom
//
//  Created by Everson Trindade on 8/17/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *praiasLista, *annotationArray;
@property (strong, nonatomic) CLLocationManager *locationManager;


- (IBAction)refresh:(id)sender;

@end
