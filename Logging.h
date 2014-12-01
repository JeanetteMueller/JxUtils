//
//  Logging.h
//
//  Created by Jeanette Müller on 04.09.13.
//  MIT Licence
//


#if defined(CONFIGURATION_AppStore) || defined(CONFIGURATION_AdHoc)


#define DLog(fmt, ...)
#define LLog()
#define FLog(fvar)
#define ILog(ivar)
#define OLog(ovar)


#else


#define DLog(fmt, ...)                               NSLog((@">>> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LLog()                                       NSLog((@">>> %s [Line %d] "), __PRETTY_FUNCTION__, __LINE__)

#define FLog(fvar)                                   NSLog((@">>> %s [Line %d] %s = %f"), __PRETTY_FUNCTION__, __LINE__, #fvar, fvar)
#define ILog(ivar)                                   NSLog((@">>> %s [Line %d] %s = %i"), __PRETTY_FUNCTION__, __LINE__, #ivar, ivar)
#define OLog(ovar)                                   NSLog((@">>> %s [Line %d] %s = %@"), __PRETTY_FUNCTION__, __LINE__, #ovar, ovar)


#endif
