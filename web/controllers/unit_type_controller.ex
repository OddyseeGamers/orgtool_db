defmodule OrgtoolDb.UnitTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.UnitType

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    unit_types = Repo.all(UnitType)

    render(conn, "index.json-api", data: unit_types)
  end

  def create(conn, %{"unit_type" => unit_type_params}, _current_user, _claums) do
    changeset = UnitType.changeset(%UnitType{}, unit_type_params)

    case Repo.insert(changeset) do
      {:ok, unit_type} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", unit_type_path(conn, :show, unit_type))
        |> render("show.json-api", data: unit_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    unit_type = Repo.get!(UnitType, id)
    render(conn, "show.json-api", data: unit_type)
  end

  def update(conn, %{"id" => id, "unit_type" => unit_type_params}, _current_user, _claums) do
    unit_type = Repo.get!(UnitType, id)
    changeset = UnitType.changeset(unit_type, unit_type_params)

    case Repo.update(changeset) do
      {:ok, unit_type} ->
        render(conn, "show.json-api", data: unit_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    unit_type = Repo.get!(UnitType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(unit_type)

    send_resp(conn, :no_content, "")
  end
end
