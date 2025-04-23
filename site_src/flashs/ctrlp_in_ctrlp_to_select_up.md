# ctrlp.vim の選択中に Ctrl-p でひとつ上を選択するようにする
## 状況
[ctrlp.vim](https://ctrlpvim.github.io/ctrlp.vim/) を利用中に `<Ctrl-p>` を押すとデフォルトでは検索履歴でひとつ前の検索文字列に切り替わる挙動になっている。

挙動を変更して、`<Up>` キーを押したときと同様に、ひとつ上を選択するようにしたい。

## 解決
.vimrc で次のように設定すれば OK。

```
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['', '', ''],
  \ 'PrtSelectMove("k")':   ['', '', ''],
  \ 'PrtHistory(-1)':       [],
  \ 'PrtHistory(1)':        []}
```

