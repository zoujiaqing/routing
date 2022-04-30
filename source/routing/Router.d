module routing.Router;

public import routing.Route;
public import routing.HttpMethod;

import std.stdio;

import std.regex : regex, match, matchAll;
import std.array : replaceFirst;

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

        auto matches = path.matchAll(regex(`\{(\w+):([^\}]+)?\}`));
        if (matches)
        {
            string[uint] paramKeys;
            int paramCount = 0;
            string pattern = path;
            string urlTemplate = path;

            foreach (m; matches)
            {
                paramKeys[paramCount] = m[1];
                string reg = m[2].length ? m[2] : "\\w+";
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

    RoutingHandler metch(string path, HttpMethod method)
    {
        auto route = metchRoute(path);

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

        return route.find(method);
    }

    Route!RoutingHandler metchRoute(string path)
    {
        auto route = _routes.get(path, null);

        if (route !is null)
        {
            return route;
        }

        foreach ( r ; _regexRoutes)
        {
            auto matched = path.match(regex(r.pattern));

            return r;

            // if (matched)
            // {
            //     route = r.copy();
            //     string[string] params;
            //     foreach (i, key; route.getParamKeys())
            //     {
            //         params[key] = decode(matched.captures[i + 1]);
            //     }

            //     route.setParams(params);
            //     return route;
            // }
        }

        return route;
    }
}
