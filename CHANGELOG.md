## [0.1.0] - Wednesday, 10th February 2021.

* Migrated from `Provider` to `Get`.
* Added `StatusIndicator` for handling `StatusMixin` in the UI.
* Restructered the source code.
* Improved the documentation for `ProcessMixin` and `StatusMixin`.
* Improved error handling if `ZAP.init()` is not called.
* Removed unused helper stuff. Cleaner code base 😊.

## [0.0.4+3] - Saturday, 16th January 2021.

* Improved error handling in `APIError`.

## [0.0.4+2] - Saturday, 16th January 2021.

* Added value `delete` to enum `RequestType`.

## [0.0.4+1] - Saturday, 16th January 2021.

* `HTTPMixin` was not exposed from the library, fixed that.


## [0.0.4] - Saturday, 16th January 2021.

* Added `HTTPMixin` to handle safe HTTP requests with a lot of detailed error logging, integrates well with   `Response`.


## [0.0.3] - Saturday, 14th November 2020.

* Added new booleans `isDesktop`, `isTablet` and `isMobile` to `SizeConfig` to check screen type based on screen dimensions. 
  Use it like this: `sizeConfig.isDesktop`


## [0.0.2] - Thursday, 12th November 2020.

* Added a `DeviceScreenType screenType` field for fetching wether screen is a Desktop, Tablet, Mobile or Watch for responsive Flutter Web development.

## [0.0.1] - Sunday, 7th November 2020.

* Inital release with Flutter helpers for the original `zap_architecture` package.
