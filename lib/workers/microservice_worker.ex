defmodule ImgOut.MicroserviceWorker do
  @moduledoc """
  Worker for microservices using Plug
  """

  use Plug.Router
  alias ImgOut.ThumbMicroservice

  plug Plug.Logger
  plug Plug.Static, at: "/", from: "public"
  plug :match
  plug :dispatch

  get "/:id/:dimensions" do
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
end
