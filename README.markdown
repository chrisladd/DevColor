<div style="float:left; margin-right:20px;">
<img src="https://github.com/chrisladd/DevColor/raw/master/images/devColor128.png" />
</div>
<h1>DevColor</h1>
Free app for Mac OSX. Download v0.1 [here](https://github.com/downloads/chrisladd/DevColor/DevColor.zip)

###Simple Color Strings by Chris Ladd

DevColor is a simple, graphical tool created with a single goal: to make my life as an iOS, Mac and web developer better.  For the past several months I've been using DevColor every day as a lightweight tool to generate color-representing strings in a variety of formats. Now you can too.

The DevColor interface is a simple panel:

![Dev color in green](https://github.com/chrisladd/DevColor/raw/master/images/greenUI.png)

Just click the large color well in the center to bring up the OSX color picker. As you choose any color from the color picker, you'll automatically update the main color well, and the string representation of that color well's color:

![Just click the large color well to bring up the color panel](https://github.com/chrisladd/DevColor/raw/master/images/greenUIWithPicker.png)

Currently supported color representations are:

- UIColor 


![UIColor](https://github.com/chrisladd/DevColor/raw/master/images/UIColorSnippet.png)

- NSColor


![NSColor](https://github.com/chrisladd/DevColor/raw/master/images/NSColorSnippet.png)

- Hex (web)


![Hex](https://github.com/chrisladd/DevColor/raw/master/images/HexColorSnippet.png)

- rgba (web)


![RGBA](https://github.com/chrisladd/DevColor/raw/master/images/RGBAColorSnippet.png)

- rgb (web)


![RGB](https://github.com/chrisladd/DevColor/raw/master/images/RGBSnippet.png)



Choose a color, then copy it to your clipboard:

![Copy to clipboard](https://github.com/chrisladd/DevColor/raw/master/images/copyToClipboardButton.png)

You may also, naturally, use the shortcut "Command + C" to copy.

For Objective-C style color strings, you can choose whether you prefer RGB or HSV style strings in the DevColor menu. 

![Prefer RGB? Go for it.](https://github.com/chrisladd/DevColor/raw/master/images/devColor_preferRGB.png)


###Importing colors (a.k.a. 'Pasting')

Often, you'll have colors represented as strings within a project you're already working on, and you may want to use DevColor to either tweak those colors, or convert them to a different format. Simply select the string in question in your project (for instance: #000). Copy that string to your clipboard, and, in DevColor, paste it into the main window either through the DevColor => Get Color From Clipboard menu item, or by simply using the shortcut "Command + V". 

![Get color from pasteboard](https://github.com/chrisladd/DevColor/raw/master/images/devColor_getColor.png)

DevColor will translate that string into whatever representation you're currently viewing, for instance, the UIColor representation of #000 would be [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.00].

This is useful if, for instance, you're building a companion website for your iPhone app, and you want to use the same colors on your website, in hex or rgba format, as you did in your app, as UIColors.





###Recent Colors

As you copy strings to your clipboard, they'll automatically be saved for you in your recent colors pallet, to the immediate left of the main color panel. 

![Recent colors](https://github.com/chrisladd/DevColor/raw/master/images/devColor_recents.png)


These are overwritten automatically, in order, as you work, so if you want a particular color to stick around, click the little lock icon next to any color well. That color will be saved and not overwritten until you unlock it. But remember that you only have five savable colors, so if you lock them all, you won't be autosaving your recents anymore. 

The idea is to give a little grace period as you're working, so that if you think to yourself "Oh, man, I JUST had the perfect green… " it's easy enough to find it and save it. Just drag any recent color well to the big, main color well to work with it again.

What if you want to save MORE than 5 colors, and save them more permanently? This is something I'd like to build into DevColor -- some kind of simple table of saved colors -- but until I get to it, might I suggest a plain text file with a list? DevColor reads color strings brilliantly, so you can always paste them back in.

The reason I never prioritized this is that I figured most people would be "saving" significant colors as color representing strings within their actual projects.


##Complements


Above the main color well, you'll find the color in question represented at a variety of brightnesses. If you find you like one better than the current color, just drag it into the main color well.

![Varying brightnesses](https://github.com/chrisladd/DevColor/raw/master/images/devColor_similarBrightness.png)


Below the sliders, you'll find three bays of complementary colors corresponding to whatever color you're presently viewing. 

![Complementary colors](https://github.com/chrisladd/DevColor/raw/master/images/devColor_complements.png)


For more on how I arrive at these, check out the main DevColor NSColor category, [NSColor+DevColor.h](https://github.com/chrisladd/DevColor/blob/master/NSColor+devColor.h). You'll want to check out the complement and twinColorCousinsSeparatedByDegrees: initialOffset: methods in particular -- I've annotated how I get there in the comments. This is an area where I could use some help, so if anyone has a better idea of which colors would be useful to automatically generate, and/or how to best generate them, shoot me an email.



###Tweaking Colors
 
Use the sliders to the right of the main color well to adjust red, green, blue or hue, saturation, and brightness, respectively. 

![Tweaking colors](https://github.com/chrisladd/DevColor/raw/master/images/devColor_sliders.png)


You can also use the keyboard shortcuts:

<table><tr><td>-</td><td>Hue level down.</td></tr><tr><td>=</td><td>Hue level up.</td></tr><tr><td>[</td><td>Saturation level down</td></tr><tr><td>]</td><td>Saturation level up</td></tr><tr><td>;</td><td>Brightness level down</td></tr><tr><td>'</td><td>Brightness level up</td></tr><tr><td></td></tr></table>


I chose these keys not because of any inherent meaning, but because they're stacked on top of each other. Start with the - and = buttons, and work your way down. 

Incidentally, you can also press 'R' for a random color. You know, for kids. 


###Tweaking Strings

![Appending helpful doowhappies](https://github.com/chrisladd/DevColor/raw/master/images/devColor_append.png)

Often, in the Objective-C world, it would make life easier to append a semicolon, or to apply the [SOMECOLOR set] method if, for instance, you're implementing drawRect and just need to set the context's current color. DevColor makes this easy -- you can turn this behavior on and off through the DevColor => Append subMenu. Regardless of whether these are on or off, they will only be applied to Objective-C style strings, e.g. UIColor and NSColor.

Writing this, I realize now an option to append the # symbol to hex colors would have been helpful, also. Whoops. Next version. 

NB: The reason I chose to exclude # symbols from hex strings in the first place was because when triple clicking to select them, the # is never selected. I figured it would be easier to add a # where you want it rather than delete it every time you paste in a hex color which, in a big CSS file, is often.


###How You, Too, Can Have DevColor In Your Life

While the source code is fully available here to download and compile yourself, a compiled binary is available [here](https://github.com/downloads/chrisladd/DevColor/DevColor.zip). All code is distributed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License), meaning you can feel free to use parts of it in your own work.

I've benefitted a great deal from the generosity of others as I continue to grow as a developer. DevColor is a small way of giving back.

If you like DevColor, check out some of my other projects on my website at [http://www.ladditude.com](http://www.ladditude.com). Or you can check out my [iOS apps on the iTunes app store](http://itunes.com/apps/walksoft). Or you can follow me on Twitter at @chrisladd. Or you can buy me a beer at WWDC -- I'll be there.

Hope you like it, and please, let me know what you think. You can email me at chris + [atMeaningThe@Symbol] + ladditude + [dotMeaningA.Period] + com

-Chris

