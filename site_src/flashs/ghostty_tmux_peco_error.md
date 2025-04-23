# Ghostty + tmux + peco が動かない
(注)解決に至っていません

ghq handbook に記載のリポジトリ移動キーバインド ([ここ](https://github.com/Songmu/ghq-handbook/blob/master/ja/05-command-list.md#%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E3%81%AE%E4%B8%80%E8%A6%A7%E3%83%91%E3%82%B9%E5%8F%96%E5%BE%97%E3%82%92%E3%81%8A%E3%81%93%E3%81%AA%E3%81%86ghq-list) の peco-src) 利用時に、tmux on ghostty だとフィルタの画面が出て来ず、Ctrl-L のように画面クリアの挙動を示す。

tmux -vvvv でログをとったところ github.com/nsf/termbox-go.SetCursor で index out of range エラーが出ていることがわかった。

[この Issue](https://github.com/peco/peco/issues/516#issuecomment-1171811783)のログと同様のもので、unset TERMINFO でとりあえずエラーが出ないようになった。が、良い解決策かわからないため一旦 ghostty + tmux + peco の利用を諦めて、peco の代わりに [fzf](https://github.com/junegunn/fzf) を使うことにした。

次の設定を .zshrc に記載した：

```
fzf-src () {
    local repo=$(ghq list | fzf --reverse)
    if [ -n "$repo" ]; then
        repo=$(ghq list --full-path --exact $repo)
        BUFFER="cd ${repo}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-src
bindkey '^]' fzf-src
```

