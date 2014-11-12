//
//  SingletonMaps.h
//  
//
//  Created by Admin on 12.11.14.
//
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

typedef void (^localityBlock)(NSString*);

@interface PTGoogleMapsManager : NSObject

@property (strong, nonatomic) NSString *address;

+ (instancetype)sharedInstance;

- (void)findMap:(GMSMapView*)mapView Latitube:(CLLocationDegrees)latitube Longitube:(CLLocationDegrees)longitube;

- (void)geolocationLatitube:(CLLocationDegrees)latitube Longitube:(CLLocationDegrees)longitube locality:(localityBlock)locality;


@end
