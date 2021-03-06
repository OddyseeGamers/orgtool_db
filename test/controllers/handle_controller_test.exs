defmodule OrgtoolDb.HandleControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Handle
  alias OrgtoolDb.Player
  @valid_attrs %{handle: "some content", img: "some content", login: "some content", name: "some content"}
  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, player} = %Player{} |> Repo.insert
    valid_data = %{
      attributes: @valid_attrs,
      relationships: %{
        player: %{
          data: %{
            type: "player",
            id:   player.id
          }
        }
      }
    }
    {:ok, %{valid_data: valid_data, conn: put_req_header(conn, "accept", "application/vnd.api+json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, handle_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    handle = Repo.insert! %Handle{}
    conn = get conn, handle_path(conn, :show, handle)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(handle.id),
      "type"          => "handle",
      "relationships" => %{"player" => %{"data" => nil}},
      "attributes"    => %{
        "name"   => handle.name,
        "handle" => handle.handle,
        "img"    => handle.img,
        "login"  => handle.login
      }}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, handle_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, handle_path(conn, :create), data: valid_data
    response = json_response(conn, 201)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["player"]["data"]["id"]
    assert Repo.get_by(Handle, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, handle_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    handle = Repo.insert! %Handle{}
    conn = put conn, handle_path(conn, :update, handle), id: handle.id, data: valid_data
    response = json_response(conn, 200)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["player"]["data"]["id"]
    assert Repo.get_by(Handle, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    handle = Repo.insert! %Handle{}
    conn = put conn, handle_path(conn, :update, handle), id: handle.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    handle = Repo.insert! %Handle{}
    conn = delete conn, handle_path(conn, :delete, handle)
    assert response(conn, 204)
    refute Repo.get(Handle, handle.id)
  end
end
