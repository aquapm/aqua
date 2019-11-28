defmodule Aqua.Views.Add do
  use Aqua.Render

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

  def fail(:invalid_path_alias) do
    [
      L.p(0, [
        T.error_highlight(S.fail()),
        T.text("You are calling"),
        T.bash("mix aqua add"),
        T.text("followed by invalid"),
        T.aqua(":path"),
        T.text("or"),
        T.aqua(":alias", :no_padding),
        T.text("!")
      ]),
      L.p(2, [
        T.text("Please, ensure that you"),
        T.error_highlight("didn't skip"),
        T.text("this parameter before calling additional arguments.")
      ])
    ]
  end

  def fail(:absolute_path) do
    [
      L.p(0, [
        T.error_highlight(S.fail()),
        T.text("Given path is out of the project scope!")
      ]),
      L.ul(
        2,
        T.text("Please ensure that:"),
        [
          [
            T.text("You are not passing"),
            T.error_highlight("absolute path")
          ],
          [
            T.text("Your path"),
            T.error_highlight("is not expanding"),
            T.text("out of project scope")
          ]
        ]
      )
    ]
  end

  def fail({:no_sub_app, type, apps}) do
    [
      L.p(0, [
        T.error_highlight(S.fail()),
        T.text("For given"),
        T.aqua(inspect(type), :no_padding),
        T.text(","),
        T.text("umbrella's child application can't be found!")
      ]),
      L.ul(
        2,
        T.text("Available applications are:"),
        Enum.map(apps, &T.elixir/1)
      ),
      L.p(2, [
        T.text("Please, check your"),
        T.aqua(inspect(type)),
        T.error_highlight("again", :no_padding),
        T.text("!")
      ])
    ]
  end

  def fail({:git, reason}) do
    [
      L.p(0, [
        T.error_highlight(S.fail()),
        T.error("Git Fail!")
      ]),
      L.p(2, T.text(reason))
    ]
  end

  def fail(:inject_not_found) do
    [
      L.p(0, [
        T.error_highlight(S.fail()),
        T.text("Given inject is not defined!")
      ]),
      L.ul(
        2,
        T.text("Please ensure:"),
        [
          [
            T.text("You are calling your"),
            T.aqua("inject"),
            T.text("from"),
            T.error_highlight("right"),
            T.aqua("template")
          ],
          [
            T.aqua("Injection"),
            T.text("or it's"),
            T.aqua("alias"),
            T.text("exist"),
            T.text("for"),
            T.error_highlight("current"),
            T.aqua("template")
          ]
        ]
      )
    ]
  end

  # This is fallback for uncoverd problems
  def fail(problem) do
    L.p(0, [
      T.error_highlight(S.fail()),
      T.text(inspect(problem))
    ])
  end
end
