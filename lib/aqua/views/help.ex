defmodule Aqua.Views.Help do
  alias Aqua.Render.Terms, as: T
  alias Aqua.Render.Symbols, as: S
  alias Aqua.Render.Layout, as: L

  def aqua() do
    [
      L.p(0, [
        T.text_highlight("Welcome"),
        T.text("to"),
        T.aqua("Aqua"),
        T.text("-"),
        T.text("your project scaffolder tools!")
      ]),
      L.ul(0, T.text("List of available commands:"), [
        [
          T.elixir("new"),
          T.text("-"),
          T.text("generates new project")
        ],
        [
          T.elixir("add"),
          T.text("-"),
          T.text("adds new prefilled file to your project")
        ],
        [
          T.elixir("update"),
          T.text("-"),
          T.text("updates template caches")
        ],
        [
          T.elixir("list"),
          T.text("-"),
          T.text("displays templates and prefilled files, available to be scaffolded")
        ]
      ]),
      L.p(0, [
        T.text("In order to retreive more information about specific command - try to call"),
        T.bash("mix aqua help"),
        T.elixir("YOUR_COMMAND")
      ])
    ]
  end

  @spec fail(any()) :: no_return()
  def fail(:not_in_project) do
    [
      L.p(0, [
        T.error_highlight(S.fail()),
        T.text("You are calling"),
        T.bash("mix aqua add"),
        T.text("command not inside"),
        T.elixir("Mix project"),
        T.fs("folder", :no_padding),
        T.text("!")
      ]),
      L.p(2, [
        T.text("Please, ensure that you are in the"),
        T.error_highlight("right filesystem place", :no_padding),
        T.text(".")
      ])
    ]
  end
end
