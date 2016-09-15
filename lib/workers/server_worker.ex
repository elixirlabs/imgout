defmodule ImgOut.ServerWorker do
  @moduledoc """
  Worker for web server using Plug
  """

  use Plug.Router
  alias ImgOut.StorageWorker, as: Storage
  alias ImgOut.ImageWorker, as: Image

  plug Plug.Logger
  plug Plug.Static, at: "/", from: "public"
  plug :match
  plug :dispatch

  get "/:id/:dimensions" do
    case thumb(id, dimensions) do
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

  defp thumb(_, nil),
    do: {:error, 422, %{dimensions: "Invalid dimension format. Tip: {w}x{h}"}}
  defp thumb(_, "x"),
    do: {:error, 422, %{dimensions: "Invalid dimension format. Tip: {w}x{h}"}}
  defp thumb(id, %{"width" => "", "height" => height}),
    do: thumb(id, %{height: height})
  defp thumb(id, %{"width" => width, "height" => ""}),
    do: thumb(id, %{width: width})
  defp thumb(id, %{"width" => width, "height" => height}),
    do: thumb(id, %{width: width, height: height})
  defp thumb(id, %{} = dimensions) do
    id
    |> Storage.read
    |> Image.thumb(dimensions)
  end
  defp thumb(id, dimensions) do
    thumb(id,
      Regex.named_captures(~r/(^(?<width>\d*)x(?<height>\d*)$)/, dimensions))
  end
end
