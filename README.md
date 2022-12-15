# FUI Flat UI Kit
My package is called "fui" and it is a library of SVG icons for the Flutter framework.
This library includes 498 open source icons provided by [flaticon.com](https://www.flaticon.com/uicons/interface-icons). 
I have named this package "fui" for Flat Uicons, as these icons are flat and easy to use in any design.

The "fui" library is easy to install and use in any Flutter project. 
Once installed, users will have access to a wide range of SVG icons that can be easily used in their designs.
The icons are high quality and are designed for use in mobile and desktop applications.

In addition to being easy to use, the "fui" library is also completely free and is distributed under an open source license.
This means that anyone can use these icons in their projects without worrying about copyright.

In summary, "fui" is a library of SVG icons for Flutter that includes 498 high-quality open source icons.
It is easy to install and use, and is available for free under an open source license.
If you need high-quality icons for your Flutter projects, "fui" is a great option.

FUI Kit is an easy-to-install Flutter library that contains 498 SVG icons. With FUI Kit, you can easily add high-quality icons to any Flutter project.

## Installation

To use FUI Kit in your Flutter project, add the following to your pubspec.yaml file:
```
dependencies:
fui_kit: <latest_version>
```

Then, run flutter packages get to install the library.

## Usage

To use an icon from FUI Kit in your Flutter project, simply use the FUI() widget, like so:

```
FUI(file: FUIcons.solidRounded.bookmark,color: Colors.amber)
// The FUI() widget takes two named arguments:

file: This is the path to the icon you want to use.
color: This is the color you want to apply to the icon.
```
You can find a list of all available icons and their corresponding paths in the API reference.

## Examples

Here are some examples of how you can use FUI Kit in your Flutter project:

```
// Use a solid rounded icon
FUI(
	file: FUIcons.solidRounded.bookmark,
	color: Colors.amber, // optional
	with:40, // optional
	height:40 // optional
)
```

```
// Use a solid square icon
FUI(file: FUIcons.solidSquare.heart,color: Colors.red)

// Use a regular rounded icon
FUI(file: FUIcons.regularRounded.user,color: Colors.blue)

// Use a regular square icon
FUI(file: FUIcons.regularSquare.comment,color: Colors.green)
```
````
import 'package:fui_kit/fui_kit.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FUI(
      file: FUIcons.solidRounded.bookmark,
      color: Colors.amber,
    );
  }
}

````
## Variants

-  	Regular Rounded: `FUIcons.regularRounded.bookmark`
-   Regular Straight: `FUIcons.regularRounded.bookmark`
-   Bold Rounded: `FUIcons.boldRounded.bookmark`
-   Bold Straight: `FUIcons.boldStraight.bookmark` 
-   Solid Rounded: `FUIcons.solidRegular.bookmark` 
-   Solid Straight: `FUIcons.solidRegular.bookmark` 

## List icons
[See all icons](https://wp.me/pd2qu8-hH)

___

With FUI Kit, you can easily add high-quality icons to any Flutter project. Give it a try and see how it can enhance your app!

fui_kit is a powerful and flexible tool that can help you add high-quality icons to your Flutter app quickly and easily. Whether you're building a shopping app, a social network, or any other type of app, fui_kit has the icons you need to make your app stand out.