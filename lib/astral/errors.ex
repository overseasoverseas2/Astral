defmodule Astral.Lib.Errors.ApiError do
  @derive {Jason.Encoder,
           only: [
             :errorCode,
             :errorMessage,
             :messageVars,
             :numericErrorCode,
             :originatingService,
             :intent
           ]}
  defstruct [
    :errorCode,
    :errorMessage,
    :messageVars,
    :numericErrorCode,
    :originatingService,
    :intent
  ]

  def new(code, message, numeric, _status_code, messageVars \\ []) do
    %__MODULE__{
      errorCode: code,
      errorMessage: message,
      messageVars: messageVars,
      numericErrorCode: numeric,
      originatingService: "Astral",
      intent: "unknown"
    }
  end

  def with_message(%__MODULE__{} = error, message) do
    %{error | errorMessage: message}
  end

  def variable(%__MODULE__{errorMessage: message} = error, variables) do
    replacables =
      Regex.scan(~r/{(\d+)}/, message)
      |> Enum.map(fn [_, index] -> String.to_integer(index) end)

    message =
      Enum.reduce(replacables, message, fn placeholder_index, acc ->
        variable = Enum.at(variables, placeholder_index)
        if variable, do: String.replace(acc, "{#{placeholder_index}}", variable), else: acc
      end)

    %{error | errorMessage: message}
  end

  def originatingService(%__MODULE__{} = error, service) do
    %{error | originatingService: service}
  end

  def with(%__MODULE__{} = error, message_variables) do
    %{error | messageVars: error.messageVars ++ message_variables}
  end

  def apply(%__MODULE__{
        errorCode: code,
        numericErrorCode: numeric_code,
        errorMessage: message,
        originatingService: service,
        intent: intent
      }) do
    %{
      errorCode: code,
      numericErrorCode: numeric_code,
      errorMessage: message,
      originatingService: service,
      intent: intent
    }
  end

  def get_message(%__MODULE__{errorMessage: message, messageVars: vars}) do
    Enum.reduce(0..(length(vars) - 1), message, fn index, acc ->
      String.replace(acc, "{#{index}}", Enum.at(vars, index))
    end)
  end

  def shortened_error(%__MODULE__{errorCode: code, errorMessage: message}) do
    "#{code} - #{message}"
  end

  def throw_http_exception(%__MODULE__{} = error, status_code) do
    raise %Plug.Conn.WrapperError{
      conn: %Plug.Conn{status: status_code, resp_body: Jason.encode!(error)},
      reason: "HTTP Exception"
    }
  end

  def dev_message(%__MODULE__{errorMessage: message} = error, dev_mode)
      when dev_mode in ["true", "1"] do
    %{error | errorMessage: message <> " (Dev: -debug message-)"}
  end
end

defmodule Astral do
  def proxy do
    %{
      fetch_error:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.fetchError",
          "An error occurred while fetching data from {0}",
          1000,
          500
        ),
      no_response_details:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.noResponseDetails",
          "No response details were found",
          1000,
          500
        ),
      invalid_method:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.invalidMethod",
          "Invalid method",
          1000,
          500
        ),
      invalid_body:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.invalidBody",
          "Invalid body",
          1000,
          500
        ),
      invalid_query:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.invalidQuery",
          "Invalid query",
          1000,
          500
        ),
      invalid_header:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.invalidHeader",
          "Invalid header",
          1000,
          500
        ),
      invalid_url:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.invalidUrl",
          "Invalid url",
          1000,
          500
        ),
      invalid_status:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.proxy.invalidStatus",
          "Invalid status",
          1000,
          500
        )
    }
  end

  def authentication do
    %{
      invalid_header:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.invalidHeader",
          "It looks like your authorization header is invalid or missing, please verify that you are sending the correct headers.",
          1011,
          400
        ),
      invalid_request:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.invalidRequest",
          "The request body you provided is either invalid or missing elements.",
          1013,
          400
        ),
      invalid_token:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.invalidToken",
          "Invalid token {0}",
          1014,
          401
        ),
      wrong_grant_type:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.wrongGrantType",
          "Sorry, your client does not have the proper grant_type for access.",
          1016,
          400
        ),
      not_your_account:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.notYourAccount",
          "You are not allowed to make changes to other people's accounts",
          1023,
          403
        ),
      validation_failed:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.validationFailed",
          "Sorry we couldn't validate your token {0}. Please try with a new token.",
          1031,
          401
        ),
      authentication_failed:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.authenticationFailed",
          "Authentication failed for {0}",
          1032,
          401
        ),
      not_own_session_removal:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.notOwnSessionRemoval",
          "Sorry you cannot remove the auth session {0}. It was not issued to you.",
          18040,
          403
        ),
      unknown_session:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.unknownSession",
          "Sorry we could not find the auth session {0}",
          18051,
          404
        ),
      used_client_token:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.authentication.wrongTokenType",
          "This route requires authentication via user access tokens, but you are using a client token",
          18052,
          401
        ),
      oauth: %{
        invalid_body:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.invalidBody",
            "The request body you provided is either invalid or missing elements.",
            1013,
            400
          ),
        invalid_external_auth_type:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.invalidExternalAuthType",
            "The external auth type {0} you used is not supported by the server.",
            1016,
            400
          ),
        grant_not_implemented:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.grantNotImplemented",
            "The grant_type {0} you used is not supported by the server.",
            1016,
            501
          ),
        too_many_sessions:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.tooManySessions",
            "Sorry too many sessions have been issued for your account. Please try again later",
            18048,
            400
          ),
        invalid_account_credentials:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.invalidAccountCredentials",
            "Sorry the account credentials you are using are invalid",
            18031,
            400
          ),
        invalid_refresh:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.invalidRefresh",
            "The refresh token you provided is invalid.",
            18036,
            400
          ),
        invalid_client:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.invalidClient",
            "The client credentials you are using are invalid.",
            18033,
            403
          ),
        invalid_exchange:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.invalidExchange",
            "The exchange code {0} is invalid.",
            18057,
            400
          ),
        expired_exchange_code_session:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.expiredExchangeCodeSession",
            "Sorry the originating session for the exchange code has expired.",
            18128,
            400
          ),
        corrective_action_required:
          Astral.Lib.Errors.ApiError.new(
            "errors.com.epicgames.authentication.oauth.corrective_action_required",
            "Corrective action is required to continue.",
            18206,
            400
          )
      }
    }
  end

  def party do
    %{
      party_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.partyNotFound",
          "Party {0} does not exist.",
          51002,
          404
        ),
      member_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.memberNotFound",
          "Party member {0} does not exist.",
          51004,
          404
        ),
      already_in_party:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.alreadyInParty",
          "Your already in a party.",
          51012,
          409
        ),
      user_has_no_party:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.userHasNoParty",
          "User {0} has no party to join.",
          51019,
          404
        ),
      not_leader:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.notLeader",
          "You are not the party leader.",
          51015,
          403
        ),
      ping_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.pingNotFound",
          "Sorry, we couldn't find a ping.",
          51021,
          404
        ),
      ping_forbidden:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.pingForbidden",
          "User is not authorized to send pings the desired user",
          51020,
          403
        ),
      not_your_account:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.notYourAccount",
          "You are not allowed to make changes to other people's accounts",
          51023,
          403
        ),
      user_offline:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.userOffline",
          "User is offline.",
          51024,
          403
        ),
      self_ping:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.selfPing",
          "Self pings are not allowed.",
          51028,
          400
        ),
      self_invite:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.party.selfInvite",
          "Self invites are not allowed.",
          51040,
          400
        )
    }
  end

  def cloudstorage do
    %{
      file_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.cloudstorage.fileNotFound",
          "Cannot find the file you requested.",
          12004,
          404
        ),
      file_too_large:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.cloudstorage.fileTooLarge",
          "The file you are trying to upload is too large",
          12004,
          413
        ),
      invalid_auth:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.cloudstorage.invalidAuth",
          "Invalid auth credentials.",
          12006,
          401
        ),
      not_your_file:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.cloudstorage.notYourFile",
          "You cannot access this file because it is not yours.",
          12005,
          403
        ),
      internal_error:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.cloudstorage.internalError",
          "Internal server error. Please try again later.",
          12007,
          500
        )
    }
  end

  def account do
    %{
      invalid_credentials:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.invalidCredentials",
          "The credentials provided are invalid.",
          11000,
          401
        ),
      account_locked:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.accountLocked",
          "Your account has been locked due to suspicious activity.",
          11001,
          403
        ),
      account_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.accountNotFound",
          "The account you are trying to access does not exist.",
          11002,
          404
        ),
      insufficient_permissions:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.insufficientPermissions",
          "You do not have permission to perform this action.",
          11003,
          403
        ),
      invalid_request:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.invalidRequest",
          "The request you made is invalid or malformed.",
          11004,
          400
        ),
      email_in_use:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.emailInUse",
          "The email address provided is already in use.",
          11005,
          409
        ),
      password_too_weak:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.account.passwordTooWeak",
          "The password provided does not meet the security requirements.",
          11006,
          400
        )
    }
  end

  def mcp do
    %{
      profile_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.profileNotFound",
          "Sorry, we couldn't find a profile for {accountId}",
          18007,
          404
        ),
      empty_items:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.emptyItems",
          "No items found",
          12700,
          404
        ),
      not_enough_mtx:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.notEnoughMtx",
          "Purchase: {0}: Required {1} MTX but account balance is only {2}.",
          12720,
          400
        ),
      wrong_command:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.wrongCommand",
          "Wrong command.",
          12801,
          400
        ),
      operation_forbidden:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.operationForbidden",
          "Operation Forbidden",
          12813,
          403
        ),
      template_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.templateNotFound",
          "Unable to find template configuration for profile",
          12813,
          404
        ),
      invalid_header:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.invalidHeader",
          "Parsing client revisions header failed.",
          12831,
          400
        ),
      invalid_payload:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.invalidPayload",
          "Unable to parse command",
          12806,
          400
        ),
      missing_permission:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.missingPermission",
          "Sorry your login does not possess the permissions '{0} {1}' needed to perform the requested operation",
          12806,
          403
        ),
      item_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.itemNotFound",
          "Locker item not found",
          16006,
          404
        ),
      wrong_item_type: fn item_id, item_type ->
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.wrongItemType",
          "Item #{item_id} is not a #{item_type}",
          16009,
          400
        )
      end,
      invalid_chat_request:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.invalidChatRequest",
          "",
          16090,
          400
        ),
      operation_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.operationNotFound",
          "Operation not found",
          16035,
          404
        ),
      invalid_locker_slot_index:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.InvalidLockerSlotIndex",
          "Invalid loadout index {0}, slot is empty",
          16173,
          400
        ),
      out_of_bounds:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.mcp.outOfBounds",
          "Invalid loadout index (source: {0}, target: {1})",
          16026,
          400
        )
    }
  end

  def gamecatalog do
    %{
      game_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.gamecatalog.gameNotFound",
          "The requested game was not found.",
          14001,
          404
        ),
      invalid_game_data:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.gamecatalog.invalidGameData",
          "The game data provided is invalid or malformed.",
          14002,
          400
        ),
      server_error:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.gamecatalog.serverError",
          "An internal server error occurred while processing the request.",
          14003,
          500
        ),
      game_already_exists:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.gamecatalog.gameAlreadyExists",
          "A game with the provided information already exists.",
          14004,
          409
        )
    }
  end

  def matchmaking do
    %{
      match_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.matchmaking.matchNotFound",
          "The requested match was not found.",
          15001,
          404
        ),
      invalid_match_data:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.matchmaking.invalidMatchData",
          "The match data provided is invalid or malformed.",
          15002,
          400
        ),
      matchmaking_error:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.matchmaking.matchmakingError",
          "An error occurred during matchmaking.",
          15003,
          500
        ),
      insufficient_players:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.matchmaking.insufficientPlayers",
          "There are not enough players to start the match.",
          15004,
          400
        )
    }
  end

  def friends do
    %{
      user_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.friends.userNotFound",
          "The requested user was not found.",
          16001,
          404
        ),
      friend_request_failed:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.friends.friendRequestFailed",
          "The friend request could not be sent.",
          16002,
          500
        ),
      already_friends:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.friends.alreadyFriends",
          "You are already friends with this user.",
          16003,
          409
        ),
      request_not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.friends.requestNotFound",
          "The friend request was not found.",
          16004,
          404
        )
    }
  end

  def internal do
    %{
      unknown_error:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.internal.unknownError",
          "An unknown error occurred.",
          99999,
          500
        ),
      service_unavailable:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.internal.serviceUnavailable",
          "The service is currently unavailable. Please try again later.",
          99998,
          503
        )
    }
  end

  def basic do
    %{
      general_error:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.basic.generalError",
          "A general error occurred.",
          10000,
          500
        ),
      invalid_input:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.basic.invalidInput",
          "The input provided is invalid.",
          10001,
          400
        ),
      not_found:
        Astral.Lib.Errors.ApiError.new(
          "errors.com.epicgames.basic.notFound",
          "The requested resource was not found.",
          10002,
          404
        )
    }
  end
end
