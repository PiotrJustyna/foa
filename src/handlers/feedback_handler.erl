%%%-------------------------------------------------------------------
%% @doc feedback handler
%% @end
%%%-------------------------------------------------------------------

-module(feedback_handler).

%% API
-export([init/2]).

-export([allowed_methods/2]).

-export([content_types_accepted/2]).

-export([create_feedback/2]).

%%====================================================================
%% API
%%====================================================================

init(Req, State) -> {cowboy_rest, Req, State}.

%%--------------------------------------------------------------------
allowed_methods(Req, State) ->
    {[<<"POST">>], Req, State}.

%%--------------------------------------------------------------------
content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"json">>, []},
       create_feedback}],
     Req, State}.

%%--------------------------------------------------------------------
create_feedback(Req0, State) ->
    quickrand:seed(), % required for get_v4_urandom
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    FileName = uuid:uuid_to_string(uuid:get_v4_urandom()),
    io:format("Received: ~w~n", [Data]),
    file:write_file(io_lib:format("~s.txt", [FileName]), Data),
    {true, Req1, State}.

%%====================================================================
%% Internal functions
%%====================================================================

