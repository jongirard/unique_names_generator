import Config

if Mix.env() == :dev do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix update_info_if_data_changed"}
        ]
      ],
      pre_push: [
        tasks: [
          {:cmd, "mix credo --strict"},
          {:cmd, "mix format"}
        ]
      ]
    ]
end
