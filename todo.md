# Todo List for ATD Gem

## Me Things

 1. Benchmark this against sinatra and rails
 2. Allow different templating systems (and default layout generation)
 3. Asset preprocessing
 4. Route declaration in hash-ish form (e.g. `Routes.get = {"/" => "home.html", "/page" => "page.erb"}`)
 5. Autotesting
 	Example

```
	get "/", "page.html" do
		if ???
			should do
				return "page.html"
			end
		elsif ???
			should do
				redirect "/"
			end
		end
	end
```

Output example (not related to input above):

```
assumes /test should return test.html
assumes /fred should return sean.html

Sucess! /test -> test.html
Failure! /fred !=> sean.html (/fred => fred.html)
```

 6. Add helper methods, e.g. redirect, params, etc. (from sinatra)
 7. Enable controller structure (file seperation, rails style)
 8. Try out websocket (volt uses `faye-websockets`) and opal
 9. Setup auto updating of server as file is saved again (have gem query file directly each time during development)
 10. Add different behaviors for different enviroments
 11. Add databases and ORM support
 12. TEST THE WHOLE THING (learn Rack::Test)
 13. Solicit users
 14. Add naming convention of assets that makes them easy to auto-parse, requiring less "Hello World"

## Volt Things

src = https://www.youtube.com/watch?v=P27EPQ4ne7o

 1. Reactive data bindings
 2. Build apps as nested components
 3. Collections
	 - page
	 - store
	 - params
	 - cookies
	 - local_store
	 - SINATRA THINGS
 4. Components
	- Client code + Assets + server COde
	- provide Tags
	- can be gems
	- Components are like importable libs
 5. Non-traditional MVC
	 - Model -> Controller -> View -> Controller -> Model (MVVM)
 6. Tasks (Helpers?)
 7.  Validations and Permissions

Less HTTP/Rest
Auto-synch
One language
components
single framework
centralized state
unified router

## Sinatra Things

 1. Route pattern matching (`/hello/:name`) or (`/[^a-z]/`)
 2.  ... Legit, everything sinatra

## Rails Things

INVESTION COMMENCE