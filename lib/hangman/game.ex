defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :init,
    letters: [],
    used: MapSet.new(),
  )

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints
    }
  end

  def new_game() do
    new_game(Dictionary.random_word())
  end

  def make_move(game = %{ game_state: state}, _guess) when state in [:won, :lost] do
    { game, tally(game) }
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    { game, tally(game) }
  end

  def accept_move(game, _guess, true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _false) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  def score_guess(game, true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> maybe_won()
    Map.put(game, :game_state, new_state)
  end

  def score_guess(game = %{ turns_left: 1 }, _false) do
    Map.put(game, :game_state, :lost)
  end

  def score_guess(game = %{ turns_left: turns_left }, _false) do
    %{ game | game_state: :bad_guess, turns_left: turns_left - 1 }
  end

  def tally(game) do
    1
  end

  def maybe_won(true), do: :won
  def maybe_won(_), do: :good_guess
end
