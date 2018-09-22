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
    io:format("methods allowed"),
    {[<<"POST">>, <<"GET">>], Req, State}.

%%--------------------------------------------------------------------
content_types_provided(Req, State) ->
    io:format("content types provided"),
    {[{{<<"application">>, <<"json">>, []}, get_feedback}],
     Req, State}.

%%--------------------------------------------------------------------
content_types_accepted(Req, State) ->
    io:format("conent types accepted"),
    {[{{<<"application">>, <<"json">>, []},
       create_feedback}],
     Req, State}.

%%--------------------------------------------------------------------
create_feedback(Req0, State) ->
    io:format("creating feedback"),
    quickrand:seed(), % required for get_v4_urandom
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    case validate_input(Data) of
        false ->
            {false, Req1, State};
        true ->
            FeedbackId = uuid:uuid_to_string(uuid:get_v4_urandom()),
            file:write_file(get_file_name(FeedbackId), Data),
            Req2 =
            cowboy_req:set_resp_body(io_lib:format("{\"id\": \"~s\"}",
                                [FeedbackId]),
                        Req1),
            {true, Req2, State}
    end.

%%--------------------------------------------------------------------
resource_exists(Req, State) ->
    #{id := Id} = cowboy_req:match_qs([{id, [], undefined}],
				      Req),
    Res = file:list_dir("some_directory"),
    case Res of
        {ok, Filenames} -> io:format("Filenames: ~w~n", [Filenames]);
        _ -> io:format("no files found")
    end,
    {filelib:is_regular(get_file_name(Id)), Req, State}.

%%--------------------------------------------------------------------
get_feedback(Req, State) ->
    #{id := Id} = cowboy_req:match_qs([{id, [], undefined}],
				      Req),
    {ok, File} = file:read_file(get_file_name(Id)),
    {File, Req, State}.

%%====================================================================
%% Internal functions
%%====================================================================

get_file_name(FileId) ->
    io_lib:format("feedback/~s.json", [FileId]).

%%--------------------------------------------------------------------
validate_input(Data) ->
    io:format("validating input: ~w~n~s~n", [Data, Data]),
    jsx:is_json(Data).