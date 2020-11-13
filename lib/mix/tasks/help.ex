defmodule Aqua.Tasks.Help do
  alias Aqua.View

  use Aqua.Render

  def aqua() do
    [
      L.p(0, [
        T.text_highlight("Welcome"),
        T.text("to"),
        T.aqua("Aqua"),
        T.text("- your project scaffoldment tool!")
      ]),
      L.ul(0, T.text("List of available commands:"), [
        [T.initial("new"), T.text("- generates new project;")],
        [T.initial("add"), T.text("- adds new prefilled file to your project;")],
        [T.initial("update"), T.text("updates template caches;")],
        [
          T.initial("list"),
          T.text("- displays templates and prefilled files, availabel to be scaffolded;")
        ]
      ]),
      L.p(0, [
        T.text("In order to retreive more information about specific command - try to call:")
      ]),
      L.p(2, [
        T.bash("$ mix aqua help"),
        T.initial("YOUR_COMMAND")
      ])
    ]
    |> Aqua.Render.render() |> Aqua.Render.out()
  end

  def new(:aa) do
    L.p(0, [
      T.initial("new"),
      T.text("- generates new project with given"),
      T.aqua("TEMPLATE"),
      T.text("under given"),
      T.fs("PATH")
    ])
  end

  def new() do
    Mix.Shell.IO.info([
      :green,
      :bright,
      "NEW",
      :normal,
      :cyan,
      " - generates new project with given ",
      :magenta,
      :bright,
      "TEMPLATE ",
      :normal,
      :cyan,
      "under given ",
      :yellow,
      :bright,
      "PATH ",
      :normal,
      :cyan,
      "with defined (or empty) ",
      :light_yellow,
      :bright,
      "ARGS\n",
      :normal,
      :cyan,
      "This command can be run either:\n",
      View.il([
        "in ",
        :magenta,
        :bright,
        "Not an Elixir project foider",
        :normal,
        :cyan,
        ";\n"
      ]),
      View.il([
        "in ",
        :magenta,
        :bright,
        "Elixir's umbrella project root",
        :normal,
        :cyan,
        ";\n"
      ]),
      "\n",
      :green,
      :bright,
      "Usage:  ",
      :light_yellow,
      :bright,
      "mix aqua new ",
      :magenta,
      :bright,
      "TEMPLATE ",
      :yellow,
      :bright,
      "PATH ",
      :light_yellow,
      :bright,
      "[ARGS]",
      "\n",
      :normal,
      :cyan,
      "Where:\n",
      View.il([
        :magenta,
        :bright,
        "TEMPLATE",
        :normal,
        :cyan,
        " - ",
        "any available org/repo or repo with valuable template;\n"
      ]),
      View.il([
        :yellow,
        :bright,
        "PATH",
        :normal,
        :cyan,
        " - ",
        "single-level relative path, that is also a valid Elixir's project name;\n"
      ]),
      View.il([
        :light_yellow,
        :bright,
        "ARGS",
        :normal,
        :cyan,
        " - ",
        "command-line args, both special for template and Aqua's common.\n   To get details run",
        :light_yellow,
        :bright,
        " mix aqua help args",
        :normal,
        :cyan,
        ";\n"
      ]),
      "\n",
      :bright,
      :green,
      "Examples:\n",
      View.il([
        :light_yellow,
        :bright,
        "mix aqua new ",
        :magenta,
        :bright,
        "console ",
        :yellow,
        :bright,
        "bri4ka\n"
      ]),
      View.il([
        :light_yellow,
        :bright,
        "mix aqua new ",
        :magenta,
        :bright,
        "umbrella ",
        :yellow,
        :bright,
        "zonder ",
        :light_yellow,
        :bright,
        "--no-test\n"
      ]),
      View.il([
        :light_yellow,
        :bright,
        "mix aqua new ",
        :magenta,
        :bright,
        "empty ",
        :yellow,
        :bright,
        "koshchey ",
        :light_yellow,
        :bright,
        "--force\n"
      ])
    ])
  end

  def add() do
    Mix.Shell.IO.info([
      :green,
      :bright,
      "ADD",
      :normal,
      :cyan,
      " - generates new file with given ",
      :magenta,
      :bright,
      "TEMPLATE.INJECT_NAME ",
      :normal,
      :cyan,
      "under given ",
      :yellow,
      :bright,
      "PATH",
      :normal,
      :cyan,
      " or ",
      :yellow,
      :bright,
      "ALIAS ",
      :normal,
      :cyan,
      "with defined (or empty) ",
      :light_yellow,
      :bright,
      "ARGS\n",
      :normal,
      :cyan,
      "This command can be run either:\n",
      View.il([
        "in ",
        :magenta,
        :bright,
        "Elixir project foider",
        :normal,
        :cyan,
        " - and the file will be created as a part of a current project;\n"
      ]),
      View.il([
        "in ",
        :magenta,
        :bright,
        "Elixir's umbrella project root",
        :normal,
        :cyan,
        " - and the file will be created as a part of one of the children projects;\n"
      ]),
      "\n",
      :green,
      :bright,
      "Usage:  ",
      :light_yellow,
      :bright,
      "mix aqua add ",
      :magenta,
      :bright,
      "TEMPLATE.INJECT_NAME ",
      :yellow,
      :bright,
      "PATH | ALIAS ",
      :light_yellow,
      :bright,
      "[ARGS]",
      "\n",
      :normal,
      :cyan,
      "Where:\n",
      View.il([
        :magenta,
        :bright,
        "TEMPLATE",
        :normal,
        :cyan,
        " - ",
        "any available org/repo or repo with valuable template;\n"
      ]),
      View.il([
        :magenta,
        :bright,
        "INJECT_NAME",
        :normal,
        :cyan,
        " - ",
        "name for available ",
        :magenta,
        :bright,
        "inject",
        :normal,
        :cyan,
        ", that is presented in given ",
        :magenta,
        :bright,
        "TEMPLATE",
        :normal,
        :cyan,
        ";\n"
      ]),
      View.il([
        :yellow,
        :bright,
        "PATH",
        :normal,
        :cyan,
        " - ",
        "any level valid path, that after evaluation is expanded to be inside current project;\n"
      ]),
      :light_cyan,
      :bright,
      "   OR\n",
      View.il([
        :yellow,
        :bright,
        "ALIAS",
        :normal,
        :cyan,
        " - ",
        "any valid ",
        :magenta,
        :bright,
        "Elixir's module name",
        :normal,
        :cyan,
        ", that can be resolved as:\n",
        "   ",
        View.il([
          "for ",
          :green,
          :bright,
          "umbrella",
          :normal,
          :cyan,
          "    - module inside for one of the child projects;\n"
        ]),
        "   ",
        View.il([
          "for ",
          :green,
          :bright,
          "standalone",
          :normal,
          :cyan,
          "  - any valid Elixir module;\n"
        ])
      ]),
      View.il([
        :light_yellow,
        :bright,
        "ARGS",
        :normal,
        :cyan,
        " - ",
        "command-line args, both special for template and Aqua's common.\n   To get details run",
        :light_yellow,
        :bright,
        " mix aqua help args",
        :normal,
        :cyan,
        ";\n"
      ]),
      "\n",
      :bright,
      :green,
      "Examples:\n",
      View.il([
        :light_yellow,
        :bright,
        "mix aqua add ",
        :magenta,
        :bright,
        "otp.gs ",
        :yellow,
        :bright,
        "Bri4ka.Servers.UserServer",
        :light_yellow,
        :bright,
        " --via\n"
      ]),
      View.il([
        :light_yellow,
        :bright,
        "mix aqua add ",
        :magenta,
        :bright,
        "empty.struct ",
        :yellow,
        :bright,
        "./apps/../apps/db/schemas/user.ex\n"
      ])
    ])
  end

  def run([command_name | _args]) do
    case function_exported?(Aqua.Tasks.Help, String.to_atom(command_name), 0) do
      true -> Kernel.apply(Aqua.Tasks.Help, String.to_atom(command_name), [])
      false -> aqua()
    end
  end

  def run(_) do
    aqua()
  end
end
