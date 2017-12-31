defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :init
    assert length(game.letters) > 0
  end

  test "state isnt changed for won" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a good guess won" do
    game = Game.new_game("wib")
    game = Game.make_move(game, "w")
    game = Game.make_move(game, "i")
    game = Game.make_move(game, "b")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "bad guess" do
    game = Game.new_game("wib")
    game = Game.make_move(game, "x")
    game = Game.make_move(game, "a")
    game = Game.make_move(game, "c")
    game = Game.make_move(game, "d")
    game = Game.make_move(game, "q")
    game = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    game = Game.make_move(game, "p")
    assert game.game_state == :lost
    assert game.turns_left == 1
  end
end
