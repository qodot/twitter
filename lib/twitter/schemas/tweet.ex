defmodule Twitter.Schemas.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :nickname, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:nickname, :content])
    |> validate_required([:nickname, :content])
  end
end
