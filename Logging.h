//DEBUG LOG

#define DLog(fmt, ...)                               NSLog((@">>> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//#define DLog(fmt, ...)

#define LLog()                                       NSLog((@">>> %s [Line %d] "), __PRETTY_FUNCTION__, __LINE__)

//log float
#define FLog(fvar)                                   NSLog((@">>> %s [Line %d] %s = %f"), __PRETTY_FUNCTION__, __LINE__, #fvar, fvar)

#define ILog(ivar)                                   NSLog((@">>> %s [Line %d] %s = %i"), __PRETTY_FUNCTION__, __LINE__, #ivar, ivar)

#define OLog(ovar)                                   NSLog((@">>> %s [Line %d] %s = %@"), __PRETTY_FUNCTION__, __LINE__, #ovar, ovar)