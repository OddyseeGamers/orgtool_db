defmodule OrgtoolDb.MemberRewardController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.MemberReward

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    member_rewards = Repo.all(MemberReward)
    render(conn, "index.json-api", data: member_rewards)
  end

  def create(conn, %{"member_reward" => member_reward_params}, _current_user, _claums) do
    changeset = MemberReward.changeset(%MemberReward{}, member_reward_params)

    case Repo.insert(changeset) do
      {:ok, member_reward} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_reward_path(conn, :show, member_reward))
        |> render("show.json-api", data: member_reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    member_reward = Repo.get!(MemberReward, id)
    render(conn, "show.json-api", data: member_reward)
  end

  def update(conn, %{"id" => id, "member_reward" => member_reward_params}, _current_user, _claums) do
    member_reward = Repo.get!(MemberReward, id)
    changeset = MemberReward.changeset(member_reward, member_reward_params)

    case Repo.update(changeset) do
      {:ok, member_reward} ->
        render(conn, "show.json-api", data: member_reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    member_reward = Repo.get!(MemberReward, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member_reward)

    send_resp(conn, :no_content, "")
  end
end
