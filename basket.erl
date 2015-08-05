-module(basket).
-compile(export_all).

start(InitialItems) ->
    spawn(?MODULE, loop, [InitialItems]).

examine(Pid) ->
    Pid ! {self(), examine},
    receive
        {Pid, Items, Version} -> [Items, Version]
    end.

add(Pid, Item) ->
    Pid ! {self(), add, Item},
    receive
        {Pid, ok} -> done
    end.

remove(Pid, Item) ->
    Pid ! {self(), remove, Item},
    receive
        {Pid, ok} -> done;
        {Pid, not_found} -> not_found
    end.

upgrade(Pid) ->
    Pid ! {self(), upgrade},
    receive
        {Pid, ok} -> done
    end.

loop(State) ->
    receive
        {From, examine} -> 
            From ! {self(), State, "v0.2"},
            loop(State);
        {From, add, Item} ->
            From ! {self(), ok},
            loop([Item|State]);
        {From, remove, Item} ->
            case lists:member(Item, State) of
                true ->
                    From ! {self(), ok},
                    loop(lists:delete(Item, State));
                false ->
                    From ! {self(), not_found},
                    loop(State)
            end;
        {From, upgrade} ->
            From ! {self(), ok},
            ?MODULE:loop(State)
    end.

