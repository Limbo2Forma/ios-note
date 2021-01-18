RichEditorView
--------------
[![License: BSD 3](https://img.shields.io/badge/license-BSD3-blue.svg)](./LICENSE.md)
[![Cocoapods](https://img.shields.io/cocoapods/v/RichEditorView.svg)](http://cocoapods.org/pods/RichEditorView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

RichEditorView is a simple, modular, drop-in UIView subclass for Rich Text Editing (`WKWebView` wrapper).

Written in Swift 5.0 (Xcode 11.x)

Supports iOS 10 through CocoaPods or Carthage.

[Soli Deo gloria](https://perfectGod.com)

Seen in Action
--------------
![Demo](./art/Demo.gif)

Just clone the project and open `RichEditorViewSample/RichEditorViewSample.xcworkspace` in Xcode.

Features
--------

![Toolbar Demo](./art/Toolbar.gif)

- [x] Bold
- [x] Italic
- [x] Subscript
- [x] Superscript
- [x] Strikethrough
- [x] Underline
- [x] Justify Left
- [x] Justify Center
- [x] Justify Right
- [x] Heading 1
- [x] Heading 2
- [x] Heading 3
- [x] Heading 4
- [x] Heading 5
- [x] Heading 6
- [x] Undo
- [x] Redo
- [x] Ordered List
- [x] Unordered List
- [x] Indent
- [x] Outdent
- [x] Insert Image
- [x] Insert Link
- [x] Text Color
- [x] Text Background Color

Installation
------------

#### Cocoapods

If you have Cocoapods 1.0+ installed, you can use Cocoapods to include `RichEditorView` into your project.
Add the following to your `Podfile`:

```
pod 'RichEditorView', :git => 'https://github.com/cbess/RichEditorView.git', :tag => '4.0'
```

Note: the `use_frameworks!` is required for pods made in Swift.

#### Carthage

Add the following to your `Cartfile`:

```
github 'cbess/RichEditorView'
```

Using RichEditorView
--------------------

`RichEditorView` makes no assumptions about how you want to use it in your app. It is a plain `UIView` subclass, so you are free to use it wherever, however you want.

Most basic use:

```
editor = RichEditorView(frame: view.bounds)
editor.html = "<h1>Jesus is God.</h1> He died for our sins and rose from the dead by His own power. Repent and believe the gospel!"
view.addSubview(editor)
```

### Editing Text

To change the styles of the currently selected text, you just call methods directly on the `RichEditorView`:
```Swift
editor.bold()
editor.italic()
editor.setTextColor(.red)
```

If you want to show the editing toolbar `RichEditorToolbar`, you will need to handle displaying it (`KeyboardManager.swift` in the sample project is a good start). But configuring it is as easy as telling it which options you want to enable, and telling it which `RichEditorView` to work on.

```Swift
let toolbar = RichEditorToolbar(frame: CGRectMake(0, 0, 320, 44))
toolbar.options = RichEditorDefaultOption.all
toolbar.editor = editor // Previously instantiated RichEditorView
editor.inputAccessoryView = toolbar
```

Some actions require user feedback (such as select an image, choose a color, etc). In this cases you can conform to the `RichEditorToolbarDelegate` and react to these actions, and maybe display some custom UI. For example, from the sample project, we just select a random color:

```Swift
private func randomColor() -> UIColor {
    let colors = [
        UIColor.red,
        UIColor.orange,
        UIColor.yellow,
        UIColor.green,
        UIColor.blue,
        UIColor.purple
    ]

    let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
    return color
}

func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
    let color = randomColor()
    toolbar.editor?.setTextColor(color)
}
```

#### Advanced Editing

If you need even more flexibility with your options, you can add completely custom actions, by either making an object that conforms the the `RichEditorOption` protocol, or configuring a `RichEditorOptionItem` object, and adding it to the toolbar's options:

```Swift
let clearAllItem = RichEditorOptionItem(image: UIImage(named: "clear"), title: "Clear") { toolbar in
    toolbar?.editor?.html = ""
    return
}
toolbar.options = [clearAllItem]
```


Acknowledgements
----------------

* Modernized by: C. Bess
* Caesar Wirth - cjwirth@gmail.com (original author)
* [wasabeef/richeditor-android](https://github.com/wasabeef/richeditor-android) - Android version of this library (Apache v2)
* [nnhubbard/ZSSRichTextEditor](https://github.com/nnhubbard/ZSSRichTextEditor) - Inspiration and Icons (MIT)

License
-------

RichEditorView is released under the BSD 3-Clause License. See [LICENSE.md](./LICENSE.md) for details.
