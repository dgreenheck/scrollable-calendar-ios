# scrollable-calendar-ios

**Warning: In it's current state, this control is a proof of concept and is not meant to be a reusable library.**

Scrollable calendar view controller for iOS

<pre>
<img src="https://github.com/dgreenheck/scrollable-calendar-ios/blob/master/demo/calendar.gif" width="250">
</pre>

This project demonstrates a custom scrollable calendar. The calendar was implemented by subclassing `UICollectionViewController`. I also added a gradient view on top that fades out the top and bottom edges of the calendar to give it a 3D effect.

Within the `ScrollableCalendarViewController` class there are some constants for adjusting the height of the cells and the headers as well as controlling how many months you can scroll in the past and future.

## Areas of Improvement
- Localization
  - Month names aren’t localized
  - Starting day of week doesn’t change based on locale
  - Only supports Gregorian calendar (Afghanistan, Ethiopia, Iran, Nepal use a different calendar system)
- Doesn’t adapt well across different orientations
- No unit tests or UI tests
- Move layout/date logic to UICollectionViewLayout
