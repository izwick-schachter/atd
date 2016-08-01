# ATD
The (assistant) technical director of your website.


## What is it?

ATD is a web framework which drawn inspiration from Rails, Sinatra, and Volt. It seeks to combine the simpliciy, modularity, automatic updating of Volt with the simplicity of Sinatra and the vast bolierplate and production capabilites of Rails.

## Installation

To install ATD:

`gem install atd`

To create a new project:

`atd new <your_app_name>`.

This will create a folder called `<your_app_name>`, and in this folder will be your app files.

Now you're all set to begin making anything your heart desires.

## Usage

Currently, ATD is not complete, and only has limited functionallity availible. It does have the simplicity to create get and post routes.

To create a route you can use 1 of 2 possible methods. The simpler one is:

```Routes.<http method>({"<path>"=>"<output file>","<other path>" => <output file>})```

or the more advanced method being:

```
<http method> "<path>", "<output>" do
	# Whatever code you want to execute
end
```

For this method, the block is optional so it can also just be called as:

```<http method> "<path>", "<output>"```

This is the most basic fuctionality. The framework is designed so that it can gradually be build upon.

The next step would be to generate some basic assets with

`atd generate assets`

This command will generate an assets folder, in which you can put all of your assets. These will all be immediatly accessable at `/<asset_name>`. You can also put assets in subdirectories to have then accesable using the directory path with the root path being `/assets/`.

## Renderers

In ATD renderers are the last thing between your files and the client. The way they work is that they will take your files and compress, parse, and process them and set their mime types before they are sent out.

Currenly, by default, ATD only supports the following asset types/file extensions:
 - HTML (`<name>.html`)
 - CSS (`<name>.css`)
 - JS (`<name>.js`)

You can create custom renderers by modifiying ATD::Renderers. This must be done at the top of your file, before those renderers are used. If they are defined afterwards, they will then not be applied. We recommend putting them in a seperate file and then requiring it in your main file. Each renderer should have the method name of the filetype it is managing. It will be given one argument, the file it is parsing, and must either return a string (some modifieied version of the input file) or a hash which can include `:file` set to the file to be returned and/or `:mime_type` set to the mime_type to be returned. Here is how it would be done (for a .erb file):

```
module ATD::Renderers
	
	require "erb"

	def erb(file)
		return {:file => ERB.new(file).result(), :mime_type => "text/html"}
	end
end
```

## Helpers

Helper methods are methods that can be used inside routes. These can be defined in the appfile (but this option may become depricated) and should be appended to the ATD::Helpers module. For example:

```
module ATD::Helpers
	def test
		puts "Test helpers"
	end
end

It still needs to be decided how these will interact with non-static variables like `params` and `session` (see issue #3). Currently they have no access.

## Change Log

0.0.1:
 - Made assets accessable from `/<asset_name>`
 - Setup command to create assets folder (`atd generate assets`)
 - Created auto filetype recognician (so you no logner have to type `html("file.html")` you can simply use `"file.html"`)

0.0.2:
##### Bugfix!
 - Squashed a bug where the server wouldn't start unless the assets directory existed

0.0.3:
 - Completed documentation for existing methods
 - Removed duplicate methods

0.0.4:
 - Added alternate route creation method (`Routes.get({"/foo"=>"bar.html"})`)
 - Setup server autostart so that the `start` method didn't need to be at the end of all files

0.0.5:
 - Cleaned up discription

0.1.0:
Yay! Our first minor version! The reason for this is becasue we have begun to follow a stricter versioning scheme. Here are our rules:

    Major.minor.bugfix

Major version number 1 will indicate readiness for public use. Major versions will include non-backwards compatable changes and will be for large systemic changes in the way things are written and/or the way the program works.
Minor versions will be for backwards compatible new features and backwards compatible modifications or code cleanup.
Bugfix versions will be for... well... bugfixs, which we hope to never need.

What else is new in 0.1.0?
 - We have now added the posibility to use custom renderers, which can be included as discribed in the renderers section of this page.
 - Our todo list has been moved from here to githubs issue tracker, where it will be much easier to manage.

0.1.1:
And promptly after that optimisic "No more bugs!" in the last version we have our first bug! I forgot to put "end" in handlers.rb.

0.2.0:
 - (Issue #2) Added self detecting file extensions, so if you don't want to type out the whole asset name, you can just end it in a . (assuming no similarly named files), and the program will autoresolve the extension.
 - (Issue #5) Added helper methods (they were usable before), adding a supported way to use them, as you can see in the helper section of this README.

0.2.1:
 - Forgot to resolve merge conflict

0.2.2:
 - Refrenced no longer existant class.

## Issues/Bugs/Feature Requests/Todo list

Use the github issue tracker.

## Contributing
##### Any help you can give would be increbible, please don't be shy

If you want to contribute, please just shoot me an email at izwick.schachter@gmail.com. I would love any help I can get from any level of developer. Especailly if you have expierence with volt. I have absolutly no expierence so it would be really create to have someone onboard who can help me implient some volt-like functionality. I would also like somebody who can help me write tests (someone with Rack::Test expierence) for this project because I am not good at writing tests.
