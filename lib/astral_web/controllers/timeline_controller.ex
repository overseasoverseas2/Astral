defmodule AstralWeb.TimelineController do
  use AstralWeb, :controller
  
# season is hard coded need tiva to add his version finder

def timeline(conn, _params) do 
   active_Events = [
 %{
   eventType: "EventFlag.Season6",               
  activeUntil: "9999-12-31T23:59:59.999Z",
  activeSince: "2019-12-31T23:59:59.999Z"  
   }, 
   %{ 
    eventType: "EventFlag.LobbySeason6",            
  activeUntil: "9999-12-31T23:59:59.999Z",  
  activeSince: "2019-12-31T23:59:59.999Z"
  }
   ]

  response = %{
    channels: %{
      "client-matchmaking" => %{
        states: [],
        cacheExpire: "9999-01-01T00:00:00.000Z"
      },
      "client-events" => %{
        states: [
          %{
            validFrom: "0001-01-01T00:00:00.000Z",
            activeEvents: active_Events,
            state: %{
              activeStorefronts: [],
              eventNamedWeights: %{},
              seasonNumber: "6.00",
              seasonTemplateId: "AthenaSeason:athenaseason6",
              matchXpBonusPoints: 0,
              seasonBegin: "2020-01-01T00:00:00Z",
              seasonEnd: "9999-01-01T00:00:00Z",
              seasonDisplayedEnd: "9999-01-01T00:00:00Z",
              weeklyStoreEnd: "9999-01-01T00:00:00Z",
              stwEventStoreEnd: "9999-01-01T00:00:00.000Z",
              stwWeeklyStoreEnd: "9999-01-01T00:00:00.000Z",
              sectionStoreEnds: %{
                "Featured" => "9999-01-01T00:00:00.000Z"
              },
              dailyStoreEnd: "9999-01-01T00:00:00.000Z"
            }
          }
        ],
        cacheExpire: "9999-01-01T00:00:00.000Z"
      }
    },
    eventsTimeOffsetHrs: 0,
    cacheIntervalMins: 10,
    currentTime: DateTime.utc_now()  |> DateTime.truncate(:second) |> DateTime.to_iso8601()
  }
  conn
  |> put_status(:ok)
  |> json(response)
end
end