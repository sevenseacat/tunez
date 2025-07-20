defmodule Tunez.Accounts.Changes.SendNewAlbumNotifications do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    Ash.Changeset.after_action(changeset, fn _changeset, album ->
      Tunez.Music.followers_for_artist!(album.artist_id, stream?: true)
      |> Stream.map(fn %{follower_id: follower_id} ->
        %{album_id: album.id, user_id: follower_id}
      end)
      |> Ash.bulk_create!(Tunez.Accounts.Notification, :create, authorize?: false, notify?: true)

      {:ok, album}
    end)
  end
end
