defmodule Boggle do
  @moduledoc """
    Add your boggle function below. You may add additional helper functions if you desire.
    Test your code by running 'mix test' from the tester_ex_simple directory.
  """

  def boggle(board, words) do
    root = %Trie{}
    root = fillTrie(words, root)
    rows = tuple_size(board)
    cols = tuple_size(board)
    visit = []
    res = %{}
    GlobalMap.start_link(%{})

    for r <- 0..(rows - 1), c <- 0..(cols - 1) do
      dfs(r, c, root, "", board, rows, cols, res, visit)
    end

    GenServer.call(GlobalMap, :get_map)
  end

  def fillTrie(words, trie) do
    Enum.reduce(words, trie, fn word, acc ->
      Trie.insert(acc, word)
    end)
  end

  def dfs(r, c, node, word, board, rows, cols, res, visit) do
    if(
      r < 0 or c < 0 or r == rows or c == cols or
        !Trie.starts_with(node, elem(elem(board, r), c)) or Enum.member?(visit, {r, c})
    ) do
    else
      # visit = MapSet.put(visit, {r, c})
      visit = visit ++ [{r, c}]
      node = Trie.get_node(node, elem(elem(board, r), c))
      word = word <> elem(elem(board, r), c)

      if node.complete == true do
        # res = Map.put(res, word, MapSet.to_list(visit))
        :ok = GenServer.call(GlobalMap, {:update, word, visit})
      end

      dfs(r - 1, c, node, word, board, rows, cols, res, visit)
      dfs(r + 1, c, node, word, board, rows, cols, res, visit)
      dfs(r, c - 1, node, word, board, rows, cols, res, visit)
      dfs(r, c + 1, node, word, board, rows, cols, res, visit)
      dfs(r + 1, c + 1, node, word, board, rows, cols, res, visit)
      dfs(r - 1, c - 1, node, word, board, rows, cols, res, visit)
      dfs(r - 1, c + 1, node, word, board, rows, cols, res, visit)
      dfs(r + 1, c - 1, node, word, board, rows, cols, res, visit)
      _visit = List.delete(visit, {r, c})
      # res
    end
  end
end
