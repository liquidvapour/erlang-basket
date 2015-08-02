-module(basket).
-compile(export_all).

loop(State) ->
    receive
        {From, examine} -> 
            From ! {self(), State},
            loop(State)
    end.

