
# Reservation 0.1: intro
---

###### 2017. 1. 2.

String:

* range:fromNSRange and nsRange:fromRange has been implemented from [http://stackoverflow.com/a/30404532/6444068](http://stackoverflow.com/a/30404532/6444068).

NewBranchViewController:

* name textField became firstResponder.
* save Button is not activated when some fields are blank.
* save Button is activated when all textFields are filled any string on typing.

NewReservationViewController:

* save Button is activated when all textFields are filled any string on typing.
* contentView should be refreshed to remove remained content area or fill remained view area whenever height of footer is adjusted.

---

BranchViewController:

* selected branch is transferred to ReservationTableViewController when a row is selected.

ReservationTableViewController:

* reservations only related to selected branch was requested to CoreData.
* following reservations and old reservations are divided.

NewReservationViewController:

* UIView generation for footerView happened to waste a lot of memory endlessly. Final footerView is never generated. The frame should only be replaced with keeping tableFooterView.
* (Bug) required height is not correct. 

---

CocoaPod

* CocoaPod has been installed.
