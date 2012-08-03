SmartNotifications
==================

C wrapper for NSNotifications

Usage
=====

Posting a notification:

```objective-c
post(@"NotificationName");
//or post with object 
posto(@"NotificationName", object);
```

Observing notifications:

```objective-c
//all the times @"NotificationName" is posted
when(@"NotificationName", ^{
  // do stuff here
  // the posted object is the tab00 variable
});
// just once
once(@"NotificationName", ^{
  // do stuff here
});
// k times
just(k, @"NotificationName", ^{
  // do stuff here
});
```

Invalidating a block:

```objective-c
//use the stop to invalidate the current scope and all subscopes
when(@"NotificationName", ^{
  // do stuff here
  stop    
  // this will not be executed  
});
```

Multiple events:

```objective-c
  when(@"a & b", ^{
      NSLog(@"when a & b");
  });
    
  once(@"a | b", ^{
      NSLog(@"once a | b");
  });
    
    
  when(@"a", ^{
      NSLog(@"when a");
  });
    
  post(@"a"); // will trigger @"a | b" and @"a"
  post(@"a"); // will trigger @"a"
  
  once(@"b", ^{
      NSLog(@"once b");
  });
  
  post(@"b"); // will trigger @"a & b" and @"b"
  post(@"b"); // nothing happens   
```


