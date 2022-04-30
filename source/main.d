module main;

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
		writeln("Hello user ..");
	});


	// for testing ..

	router.metch("/", HttpMethod.GET)();
	router.metch("/hello", HttpMethod.GET)();
	router.metch("/user/999", HttpMethod.GET)();
	router.metch("/hello", HttpMethod.POST)();

	writeln("How to use it?");
}
