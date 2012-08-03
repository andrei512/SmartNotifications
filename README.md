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
when(@"NotificationName", ^{
  // do stuff here
  // the posted object is the tab00 variable
});
```
