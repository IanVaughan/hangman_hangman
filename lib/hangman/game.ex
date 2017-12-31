defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :init,
    letters: []
  )

  def new_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints
    }
  end
end
