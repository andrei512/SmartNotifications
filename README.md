SmartNotifications
==================

c wrapper for NSNotifications

Usage
=====

Posting a notification:

```objective-c
post(@"NotificationName");
//or post with object
post(@"NotificationName", object);
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
