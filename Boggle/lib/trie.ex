defmodule Trie do
  defstruct children: %{}, complete: false

  def insert(trie, "") do
    %{trie | complete: true}
  end

  def insert(trie, word) do
    {char, rest} = String.split_at(word, 1)

    updated_children =
      Map.put(trie.children, char, insert_child(Map.get(trie.children, char), rest))

    %{trie | children: updated_children}
  end

  def insert_child(nil, rest), do: insert(%Trie{}, rest)
  def insert_child(child_trie, rest), do: insert(child_trie, rest)

  def contains(trie, word) do
    node = get_node(trie, word)
    node != nil && node.complete
  end

  def get_node(trie, word) do
    case word do
      "" ->
        trie

      _ ->
        {char, rest} = String.split_at(word, 1)

        case Map.get(trie.children, char) do
          nil -> nil
          child_trie -> get_node(child_trie, rest)
        end
    end
  end

  def starts_with(trie, prefix) do
    node = get_node(trie, prefix)
    node != nil
  end
end
