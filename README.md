# Parallax Header for TableView

## Description

The Parallax Header module extends the Appcelerator Titanium TableView
Wrapper module for 

https://github.com/apping/APParallaxHeader

The module is licensed under the MIT license.

## Installation

Download the latest distribution ZIP-file and consult the [Titanium Documentation](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_a_Module) on how install it.

## Quick Start

###Step1
Create the tableView with Alloy xml or pure Titanium methods.

```xml
<TableView id='table'></TableView>
```

###Step2
Create your headerView with a background image. You could use either an **ImageView** or a general **View**.

```javascript
var headerView = Ti.UI.createView({
   width: Ti.Platform.displayCaps.platformWidth,
   height: 150,
   backgroundImage: "image.png"
});
```
**Notice** that the width and height of the headerView should be assigned with a certain NUMBER like 200 or Ti.Platform.displayCaps.platformWidth.

###Step3
Setup the parallax header view for tableView.

```javascript
/**
 * - addParallaxWithView
 * @parameters
 * 1. the headerView you've created;
 * 2. the height of view that wrap the headerView.
 * 3. if you set this parameter to true, 
 *    the tableview couldn't be dragged upward anymore 
 *    if headerView reaching the top edge.
 * 4. color of the gradient cover. don't set it if you don't want a cover.  
 */
$.table.addParallaxWithView( headerView, headerView.height - 50, true, "#4A4A4A" );
```

## Author

**James Chow**  
web: http://updatedisplaylist.com
email:  james@jc888.co.uk

**Do Lin**

web: http://devportal.logicdesign.cn
email: mcdooooo@gmail.com

## Credits
[Mathias Amnell](http://twitter.com/amnell) at [Apping AB](http://apping.se) for APParallaxHeader

http://b2cloud.com.au/tutorial/uitableview-section-header-positions/

[Mads Møller](http://www.napp.dk) for showing how to override Titanium components

[Do Lin](http://twitter.com/do109) for customizing parallax header for UITableView.

## License

    Copyright (c) 2014 Do Lin

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
