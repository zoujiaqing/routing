module routing.Router;

public import routing.Route;
public import routing.HttpMethod;

import std.stdio;

import std.regex : regex, match, matchAll;
import std.array : replaceFirst;
import std.uri : decode;

class Router(RoutingHandler)
{
    private
    {
        Route!RoutingHandler[string] _routes;
        Route!RoutingHandler[] _regexRoutes;
    }
    
    Router add(string path, HttpMethod method, RoutingHandler handler)
    {
        auto route = CreateRoute(path, method, handler);

        if (route.regular)
        {
            _regexRoutes ~= route;
        }
        else
        {
            _routes[path] = route;
        }

        return this;
    }

    private Route!RoutingHandler CreateRoute(string path, HttpMethod method, RoutingHandler handler)
    {
        auto route = new Route!RoutingHandler(path, method, handler);

        auto matches = path.matchAll(regex(`\{(\w+)(:([^\}]+))?\}`));
        if (matches)
        {
            string[uint] paramKeys;
            int paramCount = 0;
            string pattern = path;
            string urlTemplate = path;

            foreach (m; matches)
            {
                paramKeys[paramCount] = m[1];
                string reg = m[3].length ? m[3] : "\\w+";
                pattern = pattern.replaceFirst(m[0], "(" ~ reg ~ ")");
                urlTemplate = urlTemplate.replaceFirst(m[0], "{" ~ m[1] ~ "}");
                paramCount++;
            }

            route.pattern = pattern;
            route.paramKeys = paramKeys;
            route.regular = true;
            route.urlTemplate = urlTemplate;
        }

        return route;
    }

    RoutingHandler metch(string path, HttpMethod method, ref string[string] params)
    {
        auto route = _routes.get(path, null);

        if (route is null)
        {
            foreach ( r ; _regexRoutes )
            {
                auto matched = path.match(regex(r.pattern));

                if (matched)
                {
                    route = r;
                    
                    foreach ( i, key ; route.paramKeys )
                    {
                        params[key] = decode(matched.captures[i + 1]);
                    }
                }
            }
        }

        if (route is null)
        {
            writeln(path, " is Not Found.");
            return cast(RoutingHandler) null;
        }

        RoutingHandler handler;
        handler = route.find(method);

        if (handler is null)
        {
            writeln(method, " method is Not Allowed.");
            return cast(RoutingHandler) null;
        }

        return handler;
    }
}
