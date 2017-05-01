defmodule OrgtoolDb.ItemView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{items: items}) do
    %{items: render_many(items, OrgtoolDb.ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{item: render_one(item, OrgtoolDb.ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    items = if item.items == nil do
      []
    else
      for i <- item.items, do: i.id
    end

    %{
      id: item.id,
      available: item.available,
      description: item.description,
      hidden: item.hidden,
      img: item.img,
      name: item.name,
      member_id: item.member_id,
      model_id: item.model_id,
      unit_id: item.unit_id,
    }
  end
end
