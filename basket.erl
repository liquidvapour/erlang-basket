-module(basket).
-compile(export_all).

start(InitialItems) ->
    spawn(?MODULE, loop, [InitialItems]).

examine(Pid) ->
    Pid ! {self(), examine},
    receive
        {Pid, Items} -> Items
    end.

loop(State) ->
    receive
        {From, examine} -> 
            From ! {self(), State},
            loop(State)
    end.

