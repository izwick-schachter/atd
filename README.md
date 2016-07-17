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

## Supported Asset Types

Currenly ATD only supports the following asset types/file extensions:
 - HTML (`<name>.html`)
 - CSS (`<name>.css`)

ATD will also compress your assets before sending them. For example, line breaks are removed from css documents to speed up your page.

## Todo List

1. Enable access to a params hash in the routes
2. Further investigate on how to imitate Volt
3. Support leaving off file extensions when naming assets in routes

## Change Log

0.0.1:
 - Made assets accessable from `/<asset_name>`
 - Setup command to create assets folder (`atd generate assets`)
 - Created auto filetype recognician (so you no logner have to type `html("file.html")` you can simply use `"file.html"`)

0.0.2:
###### Bugfix!
 - Squashed a bug where the server wouldn't start unless the assets directory existed

0.0.3:
 - Completed documentation for existing methods
 - Removed duplicate methods

0.0.4:
 - Added alternate route creation method (`Routes.get({"/foo"=>"bar.html"})`)
 - Setup server autostart so that the `start` method didn't need to be at the end of all files

## Contributing
##### Any help you can give would be increbible, please don't be shy

If you want to contribute, please just shoot me an email at izwick.schachter@gmail.com. I would love any help I can get from any level of developer. Especailly if you have expierence with volt. I have absolutly no expierence so it would be really create to have someone onboard who can help me implient some volt-like functionality. I would also like somebody who can help me write tests for this project because I am not good at writing tests.
