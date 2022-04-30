module routing.Route;

import routing.HttpMethod;

import std.stdio;

class Route(RoutingHandler)
{
    private
    {
        string _path;

        RoutingHandler[HttpMethod] _handlers;
    }

    public
    {
        // like uri path
        string pattern;

        // use regex?
        bool regular;

        // Regex template
        string urlTemplate;

        string[uint] paramKeys;

        string[string] params;
    }
    
    this(string path, HttpMethod method, RoutingHandler handler)
    {
        _path = path;
        _handlers[method] = handler;
    }

    RoutingHandler find(HttpMethod method)
    {
        auto handler = _handlers.get(method, null);

        return cast(RoutingHandler) handler;
    }

    string path()
    {
        return _path;
    }
}
