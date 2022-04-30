module main;

import std.stdio;

import routing.Router;

alias void delegate(string[string]) RequestHandler;

void main()
{
	auto router = new Router!RequestHandler;

	router.add("/", HttpMethod.GET, (string[string] params) {
		writeln("Hello index ..");
	});

	router.add("/hello", HttpMethod.GET, (string[string] params) {
		writeln("Hello world ..");
	});

	router.add("/user/{id:\\d+}", HttpMethod.GET, (string[string] params) {
		writeln("Hello user ", params["id"], " ..");
	});

	// for testing ..

	string[string] params;
	router.metch("/", HttpMethod.GET, params)(params);
	router.metch("/hello", HttpMethod.GET, params)(params);
	router.metch("/user/999", HttpMethod.GET, params)(params);
	router.metch("/hello", HttpMethod.POST, params)(params);

	writeln("How to use it?");
}
