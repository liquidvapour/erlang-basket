-module(basket).
-compile(export_all).

start(InitialItems) ->
    spawn(?MODULE, loop, [InitialItems]).

loop(State) ->
    receive
        {From, examine} -> 
            From ! {self(), State},
            loop(State)
    end.

