defmodule ForzaAssignment.Utils.Fetch do
  require Logger
  def call(url, params \\ %{}) do
    case HTTPoison.get(url, [], params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response_body = body
        |> Poison.decode!

        {:ok, response_body["matches"]}
      {:ok, %HTTPoison.Response{status_code: 503}} ->
        Logger.info("Service unavailable. Retry later.")
        {:error, []}
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        Logger.info("Invalid request params")
        {:error, []}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.info(reason)
        IO.puts reason
        {:error, []}
    end
  end
end
