defmodule Twitter.Tweets do
  import Ecto.Query, warn: false

  alias Twitter.Repo
  alias Twitter.Schemas.Tweet

  def tweet(nickname, content) do
    %Tweet{}
    |> Tweet.changeset(%{nickname: nickname, content: content})
    |> Repo.insert!()
  end

  def timeline() do
    from(t in Tweet,
      order_by: [desc: t.inserted_at]
    )
    |> Repo.all()
  end
end
