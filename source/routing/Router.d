module routing.Router;

public import routing.Route;
public import routing.HttpMethod;

import std.stdio;

class Router(RoutingHandler)
{
    private
    {
        Route!RoutingHandler[string] _routes;
    }
    
    Router add(string path, HttpMethod method, RoutingHandler handler)
    {
        _routes[path] = new Route!RoutingHandler(path, method, handler);

        return this;
    }

    RoutingHandler metch(string path, HttpMethod method)
    {
        auto handler = _routes.get(path, null);
        if (handler is null)
        {
            writeln(path, " is Not Found.");
            return cast(RoutingHandler) null;
        }

        return handler.find(method);
    }
}
