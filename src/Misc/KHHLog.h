//
//  KHHLog.h
//
//  Created by Ming Sun on 12-7-11.
//

#ifndef KHHLog_h
#define KHHLog_h

/*
 * 参考 http://iphoneincubator.com/blog/debugging/the-evolution-of-a-replacement-for-nslog
 */

// DLog is almost a drop-in replacement for NSLog
// DLog();
// DLog(@"here");
// DLog(@"value: %d", x);
// Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif
