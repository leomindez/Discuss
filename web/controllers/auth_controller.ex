defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    alias Discuss.User 
    plug Ueberauth

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do

        user_params = %{name: auth.info.name, email: auth.info.email, provider: "github", token: auth.credentials.token, username: auth.info.nickname}
        changeset = User.changeset(%User{}, user_params)

        signing(conn, changeset)
    end

    def signout(conn, _params) do
        conn
        |> configure_session(drop: true) 
        |> redirect(to: topic_path(conn, :index))
    end

    defp signing(conn,changeset) do

        case insert_or_update_user(changeset) do

            {:ok, user} ->
                conn
                |> put_flash(:info, "Welcome back to Discuss")
                |> put_session(:user_id, user.id)
                |> redirect(to: topic_path(conn, :index))

            {:error, reason} ->
                IO.inspect(reason)
                conn
                |> put_flash(:error, "Error singing in ")
                |>redirect(to: topic_path(conn,:index))
        end
            
    end

    defp insert_or_update_user(changeset) do
       case Repo.get_by(User, username: changeset.changes.username) do
           nil ->
            Repo.insert(changeset)
        user ->
            {:ok, user}
       end
    end
    
end