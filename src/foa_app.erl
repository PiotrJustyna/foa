%%%-------------------------------------------------------------------
%% @doc foa public API
%% @end
%%%-------------------------------------------------------------------

-module(foa_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_', [{"/feedback", feedback_handler, []}]}]),
    {ok, _} = cowboy:start_clear(foa_http_listener, [{port, 3000}], #{env => #{dispatch => Dispatch}}),
    foa_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
