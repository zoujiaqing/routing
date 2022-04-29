# routing

# Sample code
```D
import std.stdio;

import routing.Router;

alias void delegate() RequestHandler;

void main()
{
	auto router = new Router!RequestHandler;

	router.add("/", HttpMethod.GET, () {
		writeln("Hello index ..");
	});

	router.add("/hello", HttpMethod.GET, () {
		writeln("Hello world ..");
	});

	router.add("/user/{id:\\d+}", HttpMethod.GET, () {
		writeln("Hello world ..");
	});


	// for testing ..

	router.metch("/", HttpMethod.GET)();
	router.metch("/hello", HttpMethod.GET)();
	router.metch("/user/999", HttpMethod.GET)();

	writeln("How to use it?");
}

```
