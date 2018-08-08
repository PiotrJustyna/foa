%%%-------------------------------------------------------------------
%% @doc feedback handler
%% @end
%%%-------------------------------------------------------------------

-module(feedback_handler).

%% API
-export([init/2]).

-export([allowed_methods/2]).

-export([content_types_provided/2]).

-export([content_types_accepted/2]).

-export([create_feedback/2]).

-export([resource_exists/2]).

-export([get_feedback/2]).

%%====================================================================
%% API
%%====================================================================

init(Req, State) -> {cowboy_rest, Req, State}.

%%--------------------------------------------------------------------
allowed_methods(Req, State) ->
    {[<<"POST">>, <<"GET">>], Req, State}.

%%--------------------------------------------------------------------
content_types_provided(Req, State) ->
    {[{{<<"text">>, <<"plain">>, []}, get_feedback}], Req,
     State}.

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
    io:format("Received: ~s~n", [Data]),
    file:write_file(io_lib:format("feedback/~s.txt",
				  [FileName]),
		    Data),
    Req2 = cowboy_req:set_resp_body(FileName, Req1),
    {true, Req2, State}.

%%--------------------------------------------------------------------
% TODO
resource_exists(Req, State) -> {true, Req, State}.

%%--------------------------------------------------------------------
get_feedback(Req, State) ->
    #{id := Id} = cowboy_req:match_qs([{id, [], undefined}],
				      Req),
    {Id, Req, State}.

%%====================================================================
%% Internal functions
%%====================================================================

