defmodule ImgOut.ImageWorkerTest do
  use ExUnit.Case, async: true
  alias ImgOut.ImageWorker

  @content "some content"

  test "return input if {:ok, binary} tuple given" do
    original = File.read!("./test/fixtures/elixir.png")
    {:ok, thumb, content_type} = ImageWorker.thumb({:ok, original},
      %{width: 16, height: 16})
    refute thumb == original
    assert content_type == "image/png"
  end

  test "return input if error content given" do
    assert ImageWorker.thumb({:error, 422, %{}}, %{}) == {:error, 422, %{}}
  end
end
