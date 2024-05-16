#![allow(non_snake_case, non_camel_case_types, dead_code)]
use std::collections::{HashMap, HashSet};

/*
    Fill in the boggle function below. Use as many helpers as you want.
    Test your code by running 'cargo test' from the tester_rs_simple directory.

    To demonstrate how the HashMap can be used to store word/coord associations,
    the function stub below contains two sample words added from the 2x2 board.
*/

fn boggle(board: &[&str], words: &Vec<String>) -> HashMap<String, Vec<(u8, u8)>> {
    let mut root = TrieNode::new();
    for word in words.iter() {
        root.insert(word);
    }
    let ROWS = board.len() as isize;
    let COLS = board[0].len() as isize;
    let mut found: HashMap<String, Vec<(u8, u8)>> = HashMap::new();
    let mut visit: HashSet<(isize, isize)> = HashSet::new();
    let mut coord: Vec<(u8, u8)> = Vec::new();

    // Helper function for depth-first search
    fn dfs(
        r: isize,
        c: isize,
        node: &TrieNode,
        mut word: String,
        board: &[&str],
        ROWS: isize,
        COLS: isize,
        mut visit: &mut HashSet<(isize, isize)>,
        mut coord: &mut Vec<(u8, u8)>,
        mut found: &mut HashMap<String, Vec<(u8, u8)>>,
    ) {
        // Check if coordinates are out of bounds
        if r < 0 || c < 0 || r >= ROWS || c >= COLS {
            return;
        }

        let currentLetter = match board[r as usize].chars().nth(c as usize) {
            Some(ch) => ch,
            None => return,
        };

        // Check if the current position has been visited or if the letter is not in the Trie
        if visit.contains(&(r, c)) || !node.children.contains_key(&currentLetter) {
            return;
        }

        visit.insert((r, c).clone());
        coord.push((r as u8, c as u8).clone()); /////////////////

        let next = match node.children.get(&currentLetter) {
            Some(n) => n,
            None => return,
        };

        word.push(currentLetter);

        // If a word is found, add it to the found HashMap
        if next.is_end_of_word {
            found.insert(word.clone(), coord.clone()); ////////////////////
        }

        // Perform DFS in all directions
        for dr in -1..=1 {
            for dc in -1..=1 {
                if dr == 0 && dc == 0 {
                    continue; // Skip the current cell
                }
                dfs(
                    r + dr,
                    c + dc,
                    next,
                    word.clone(),
                    board,
                    ROWS,
                    COLS,
                    &mut visit,
                    &mut coord,
                    &mut found,
                );
            }
        }

        visit.remove(&(r, c));
        coord.pop();
    }

    // Iterate over all cells to start DFS
    for r in 0..ROWS {
        for c in 0..COLS {
            dfs(
                r,
                c,
                &root,
                String::new(),
                board,
                ROWS,
                COLS,
                &mut visit,
                &mut coord,
                &mut found,
            );
        }
    }

    found
}
#[derive(Default, Clone)]
struct TrieNode {
    children: HashMap<char, TrieNode>,
    is_end_of_word: bool,
}

impl TrieNode {
    pub fn new() -> Self {
        TrieNode::default()
    }

    pub fn insert(&mut self, word: &str) {
        let mut current = self;
        for c in word.chars() {
            current = current.children.entry(c).or_insert(TrieNode::default());
        }
        current.is_end_of_word = true;
    }
}
#[cfg(test)]
#[path = "tests.rs"]
mod tests;
