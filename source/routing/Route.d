module routing.Route;

import routing.HttpMethod;

class Route(RoutingHandler)
{
    private
    {
        string _path;
        RoutingHandler[HttpMethod] _handlers;
    }

    this(string path, HttpMethod method, RoutingHandler handler)
    {
        _path = path;
        _handlers[method] = handler;
    }

    RoutingHandler find(HttpMethod method)
    {
        return _handlers.get(method, null);
    }
}
