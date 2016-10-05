defmodule ImgOut.MicroserviceWorker do
  @moduledoc """
  Worker for microservices using Plug
  """

  use Plug.Router
  use Plug.ErrorHandler
  alias ImgOut.ThumbMicroservice
  alias ImgOut.MetricMicroservice

  plug Plug.Logger
  plug Plug.Static, at: "/", from: "public"
  plug ImgOut.Plug.Metric, name: "thumb", pattern: ~r/(^\/thumb)/
  plug :match
  plug :dispatch

  get "/metrics/thumb" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(MetricMicroservice.process("thumb")))
    |> halt
  end

  get "/thumb/:id/:dimensions" do
    case ThumbMicroservice.process(id, dimensions) do
      {:ok, binary, content_type} ->
        conn
        |> put_resp_content_type(content_type, nil)
        |> send_resp(200, binary)
      {:error, status, errors} ->
        err_resp(conn, status, errors)
    end
  end

  match _,
   do: err_resp(conn, 404, %{page: "Not found!"})

  defp err_resp(conn, status, errors) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(%{errors: errors}))
    |> halt
  end

  def handle_errors(conn, %{kind: kind, reason: _reason, stack: _stack}) do
    ImgOut.Plug.Metric.handle_error(conn, {"thumb", ~r/(^\/thumb)/})
    send_resp(conn, conn.status, Poison.encode!(%{errors: ["Something went wrong", kind]}))
  end
end
