defmodule ForzaAssignment.Utils.Fetch do
  def call(url, params \\ %{}) do
    case HTTPoison.get(url, [], params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response_body = body
        |> Poison.decode!

        response_body["matches"]
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts reason
    end
  end
end
