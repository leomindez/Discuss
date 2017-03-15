defmodule Discuss.User do
    use Discuss.Web, :model

    schema "users" do
      field :name, :string
      field :email, :string
      field :provider, :string
      field :token, :string
      field :username, :string
      has_many :topics, Discuss.Topic
      has_many :comments, Discuss.Comment
      timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :email, :provider, :token, :username])
        |> validate_required([:name, :email, :provider, :token, :username])
    end
end