defmodule Tutorials.Repo do
  use Ecto.Repo,
    otp_app: :tutorials,
    adapter: Ecto.Adapters.MyXQL
end
