// Generated by Apple Swift version 4.0.3 effective-3.2.3 (swiftlang-900.0.74.1 clang-900.0.39.2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_attribute(external_source_symbol)
# define SWIFT_STRINGIFY(str) #str
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name) _Pragma(SWIFT_STRINGIFY(clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in=module_name, generated_declaration))), apply_to=any(function, enum, objc_interface, objc_category, objc_protocol))))
# define SWIFT_MODULE_NAMESPACE_POP _Pragma("clang attribute pop")
#else
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name)
# define SWIFT_MODULE_NAMESPACE_POP
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import UIKit;
@import CoreLocation;
@import UserNotifications;
@import Foundation;
@import ObjectiveC;
@import MapKit;
@import WebKit;
@import CoreData;
#endif

#import "/Users/Mally/Documents/Università/Triennale/Tesi/Progetto/UNISA_EASY_DETECT_code_file_ipa/UnisaEasyDetect_2Versioni_25-10-2017/UnisaEasyDetect_v2/BeaconDetectorAPP/ObjCBridge.h"

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

SWIFT_MODULE_NAMESPACE_PUSH("BeaconDetectorAPP")
@class UIWindow;
@class CLLocationManager;
@class ESTBeaconManager;
@class UNUserNotificationCenter;
@class NSPersistentContainer;
@class UIApplication;

SWIFT_CLASS("_TtC17BeaconDetectorAPP11AppDelegate")
@interface AppDelegate : UIResponder <CLLocationManagerDelegate, NSURLSessionDelegate, UIApplicationDelegate, UNUserNotificationCenterDelegate, ESTBeaconManagerDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
@property (nonatomic, strong) CLLocationManager * _Nonnull locationManager;
@property (nonatomic, strong) ESTBeaconManager * _Nonnull beaconManager;
@property (nonatomic, strong) UNUserNotificationCenter * _Nonnull center;
@property (nonatomic, strong) NSPersistentContainer * _Nonnull persistentContainer;
- (void)saveContext;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions SWIFT_WARN_UNUSED_RESULT;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC17BeaconDetectorAPP17AulaMapAnnotation")
@interface AulaMapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable subtitle;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (nonnull instancetype)initWithLatitude:(double)latitude longitude:(double)longitude OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UILabel;
@class NSCoder;

SWIFT_CLASS("_TtC17BeaconDetectorAPP17AulaTableViewCell")
@interface AulaTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified nomeAulaLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified locationAulaLabel;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class PAula;
@class MKMapView;
@class UIProgressView;
@class CLLocation;
@class UIButton;
@class UIStoryboardSegue;
@class NSBundle;

SWIFT_CLASS("_TtC17BeaconDetectorAPP18AulaViewController")
@interface AulaViewController : UIViewController
@property (nonatomic, strong) PAula * _Nullable aulaCorrente;
@property (nonatomic, copy) NSString * _Nullable urlOrario;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified locationLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified capienzaLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified descrizioneLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified dettagliLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified CDLLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified locationTitleView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified capienzaTitleView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified descrizioneTitleView;
@property (nonatomic, weak) IBOutlet MKMapView * _Null_unspecified mapView;
@property (nonatomic, weak) IBOutlet UIProgressView * _Null_unspecified progressBar;
@property (nonatomic, readonly) CLLocationDistance regionRadius;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)centerMapOnLocationWithLocation:(CLLocation * _Nonnull)location;
- (NSArray<AulaMapAnnotation *> * _Nonnull)getMapAnnotation SWIFT_WARN_UNUSED_RESULT;
- (void)locationManagerWithManager:(CLLocationManager * _Null_unspecified)manager didUpdateLocations:(NSArray * _Null_unspecified)locations;
- (IBAction)startNavigatore:(UIButton * _Nonnull)sender;
- (void)mostraOrari;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UISearchController;
@class NSURLSession;
@class PEdificio;
@class UITableView;
@class UISearchBar;
@class NSNotification;

SWIFT_CLASS("_TtC17BeaconDetectorAPP23AuleTableViewController")
@interface AuleTableViewController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating, UITextFieldDelegate>
@property (nonatomic, strong) UISearchController * _Nullable resultSearchController;
@property (nonatomic, copy) NSArray<PAula *> * _Null_unspecified list;
@property (nonatomic, copy) NSArray<PAula *> * _Nonnull filtered;
@property (nonatomic, strong) AulaTableViewCell * _Nonnull cellModified;
@property (nonatomic, readonly, strong) NSURLSession * _Nonnull session;
@property (nonatomic) NSInteger edificiNumber;
@property (nonatomic, copy) NSArray<PEdificio *> * _Nonnull edifici;
@property (nonatomic, copy) NSDictionary<NSString *, NSArray<PAula *> *> * _Nonnull auleInEdifici;
- (void)viewDidLoad;
- (void)updateSearchResultsForSearchController:(UISearchController * _Nonnull)searchController;
- (void)filtraContenutiWithTestoCercato:(NSString * _Nonnull)testoCercato scope:(NSString * _Nonnull)scope;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView titleForHeaderInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (void)searchBarCancelButtonClicked:(UISearchBar * _Nonnull)searchBar;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)viewWillDisappear:(BOOL)animated;
- (void)updateTableWithNotification:(NSNotification * _Nonnull)notification;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIActivityIndicatorView;

SWIFT_CLASS("_TtC17BeaconDetectorAPP19FirstViewController")
@interface FirstViewController : UIViewController
@property (nonatomic) BOOL semaforo;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * _Null_unspecified indicator;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)viewWillAppear:(BOOL)animated;
- (void)downloadDatabaseView;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class WKWebView;
@class UIView;
@class WKNavigation;

SWIFT_CLASS("_TtC17BeaconDetectorAPP19LoginViewController")
@interface LoginViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, readonly, copy) NSString * _Nonnull baseurl;
@property (nonatomic, strong) WKWebView * _Null_unspecified webView;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nonnull infos;
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified wView;
- (void)viewDidLoad;
- (void)webView:(WKWebView * _Nonnull)webView didFinishNavigation:(WKNavigation * _Null_unspecified)navigation;
- (void)manageInfoWithInfo:(NSString * _Nonnull)info;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIWebView;

SWIFT_CLASS("_TtC17BeaconDetectorAPP24OrarioAulaViewController")
@interface OrarioAulaViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, copy) NSString * _Nullable url;
@property (nonatomic, weak) IBOutlet UIWebView * _Null_unspecified orarioAulaWebView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * _Null_unspecified indicator;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)webViewDidFinishLoad:(UIWebView * _Nonnull)webView;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSEntityDescription;
@class NSManagedObjectContext;

SWIFT_CLASS_NAMED("PAula")
@interface PAula : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface PAula (SWIFT_EXTENSION(BeaconDetectorAPP))
@property (nonatomic) int16_t capienza;
@property (nonatomic, copy) NSString * _Nullable codice;
@property (nonatomic, copy) NSString * _Nullable descrizione;
@property (nonatomic, copy) NSString * _Nullable edificio;
@property (nonatomic) double lat;
@property (nonatomic, getter=long, setter=setLong:) double long_;
@property (nonatomic, copy) NSString * _Nullable nome;
@property (nonatomic) int16_t piano;
@end


SWIFT_CLASS_NAMED("PBeacon")
@interface PBeacon : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface PBeacon (SWIFT_EXTENSION(BeaconDetectorAPP))
@property (nonatomic, copy) NSString * _Nullable aula;
@property (nonatomic) int32_t major;
@property (nonatomic) int32_t minor;
@property (nonatomic, copy) NSString * _Nullable uuid;
@end


SWIFT_CLASS_NAMED("PEdificio")
@interface PEdificio : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface PEdificio (SWIFT_EXTENSION(BeaconDetectorAPP))
@property (nonatomic, copy) NSString * _Nullable descrizione;
@property (nonatomic) double lat;
@property (nonatomic, getter=long, setter=setLong:) double long_;
@property (nonatomic, copy) NSString * _Nullable nome;
@end


SWIFT_CLASS_NAMED("PPiano")
@interface PPiano : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface PPiano (SWIFT_EXTENSION(BeaconDetectorAPP))
@property (nonatomic, copy) NSString * _Nullable descrizione;
@property (nonatomic, copy) NSString * _Nullable edificio;
@property (nonatomic) int16_t numero;
@end


SWIFT_CLASS_NAMED("PUtente")
@interface PUtente : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface PUtente (SWIFT_EXTENSION(BeaconDetectorAPP))
@property (nonatomic, copy) NSString * _Nullable anno;
@property (nonatomic, copy) NSString * _Nullable cdl;
@property (nonatomic, copy) NSString * _Nullable matr;
@property (nonatomic, copy) NSString * _Nullable nome;
@end

@class CLBeaconRegion;
@class UIBarButtonItem;
@class CLBeacon;

SWIFT_CLASS("_TtC17BeaconDetectorAPP22PresenzaViewController")
@interface PresenzaViewController : UIViewController <ESTBeaconManagerDelegate>
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) PAula * _Nullable aula;)
+ (PAula * _Nullable)aula SWIFT_WARN_UNUSED_RESULT;
+ (void)setAula:(PAula * _Nullable)value;
@property (nonatomic, strong) PAula * _Nullable aulaPrecedente;
@property (nonatomic, strong) CLBeaconRegion * _Nullable regionAula;
@property (nonatomic, copy) NSString * _Nonnull dataStringIngresso;
@property (nonatomic, strong) CLBeaconRegion * _Null_unspecified regUnisa;
@property (nonatomic, strong) ESTBeaconManager * _Nullable beaconManager;
@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger secondsCambioAula;
@property (nonatomic) BOOL inAula;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified presenzaInAulaLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified rilevazioneTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified orarioIngressoTitle;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified ultimaPresenzaTitle;
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified orarioIngressoView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified orarioIngressoLabel;
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified ultimaPresenzaView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified ultimaPresenzaLabel;
@property (nonatomic, weak) IBOutlet UIView * _Null_unspecified inCorsoView;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified presenzaButton;
- (IBAction)completaPresenzaButton:(UIButton * _Nonnull)sender;
- (IBAction)cancelPresenza:(UIBarButtonItem * _Nonnull)sender;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)beaconManager:(id _Nonnull)manager didRangeBeacons:(NSArray<CLBeacon *> * _Nonnull)beacons inRegion:(CLBeaconRegion * _Nonnull)region;
- (void)restartTimerWithNotification:(NSNotification * _Nonnull)notification;
- (void)becomeActive;
- (IBAction)chooseSegue:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITextField;
@class UIScrollView;

SWIFT_CLASS("_TtC17BeaconDetectorAPP21ProfileViewController")
@interface ProfileViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nonnull info;
@property (nonatomic) BOOL firstTime;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified welcomeLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified numLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified cdlLabel;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified annoLabel;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified editButton;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified annoText;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified okButton;
@property (nonatomic, weak) IBOutlet UIScrollView * _Null_unspecified scrollView;
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified lastSeparator;
- (void)viewDidLoad;
- (IBAction)editButtonPressed:(id _Nonnull)sender;
- (IBAction)okButtonPressed:(id _Nonnull)sender;
- (void)didReceiveMemoryWarning;
- (void)handleShowKeyBoard:(NSNotification * _Nonnull)notification;
- (void)handleHideKeyBoard:(NSNotification * _Nonnull)notification;
- (IBAction)logout:(id _Nonnull)sender;
- (void)viewWillDisappear:(BOOL)animated;
- (void)uploadStudentWithMatr:(NSString * _Nonnull)matr name:(NSString * _Nonnull)name surname:(NSString * _Nonnull)surname cdl:(NSString * _Nonnull)cdl;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC17BeaconDetectorAPP27RegistrazioneViewController")
@interface RegistrazioneViewController : UIViewController <UITextFieldDelegate>
- (void)didReceiveMemoryWarning;
- (void)viewDidLoad;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

SWIFT_MODULE_NAMESPACE_POP
#pragma clang diagnostic pop
