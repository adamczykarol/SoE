%%%-------------------------------------------------------------------
%%% @author nelsonvides
%%% @copyright (C) 2020, nelsonvides
%%% @doc
%%%
%%% @end
%%% Created : 2020-02-24 11:58:57.704068
%%%-------------------------------------------------------------------
-module(test_ct_SUITE).


%% API
-export([all/0,
         groups/0,
         init_per_suite/1,
         end_per_suite/1,
         init_per_group/2,
         end_per_group/2,
         init_per_testcase/2,
         end_per_testcase/2]).

%% test cases
-export([
         echo_protocol_does_echo/1
        ]).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

all() ->
    [
     echo_protocol_does_echo
    ].

groups() ->
    [
    ].

%%%===================================================================
%%% Overall setup/teardown
%%%===================================================================
init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.


%%%===================================================================
%%% Group specific setup/teardown
%%%===================================================================
init_per_group(_Groupname, Config) ->
    Config.

end_per_group(_Groupname, _Config) ->
    ok.


%%%===================================================================
%%% Testcase specific setup/teardown
%%%===================================================================
init_per_testcase(echo_protocol_does_echo, Config) ->
    ok = application:ensure_started(ranch),
    {ok, _Listener} = ranch:start_listener(echo_listener,
                                           ranch_tcp, #{socket_opts => [{port, 5555}]},
                                           echo_protocol, []),
    {ok, Sock} = gen_tcp:connect("localhost", 5555, [binary, {packet, 0}]),
    [{socket, Sock} | Config];
init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(echo_protocol_does_echo, Config) ->
    ok = gen_tcp:close(?config(socket, Config)),
    ranch:stop_listener(echo_listener),
    Config;
end_per_testcase(_TestCase, _Config) ->
    ok.

%%%===================================================================
%%% Individual Test Cases (from groups() definition)
%%%===================================================================

echo_protocol_does_echo(Config) ->
    _Sock = ?config(socket, Config),
    ?assert(false).
