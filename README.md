SmartNotifications
==================

c wrapper for NSNotifications

Usage
=====

Posting a notification:

```objective-c
post(@"NotificationName");
```

Observing notifications:

```objective-c
when(@"NotificationName", ^{
  // do stuff here
});
```
