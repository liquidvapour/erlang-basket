-module(basket).
-compile(export_all).

start(InitialItems) ->
    spawn(?MODULE, loop, [InitialItems]).

examine(Pid) ->
    Pid ! {self(), examine},
    receive
        {Pid, Items} -> Items
    end.

add(Pid, Item) ->
    Pid ! {self(), add, Item},
    receive
        {Pid, ok} -> done
                    end.

loop(State) ->
    receive
        {From, examine} -> 
            From ! {self(), State},
            loop(State);
        {From, add, Item} ->
            From ! {self(), ok},
            loop([Item|State])
    end.

