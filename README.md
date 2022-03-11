# System Information Extended Edition

System Information の改造版です。

無保証です。
十分なテストを行っていないので、不具合があるかもしれません。


## Build
PC やネット上で扱いやすくするために、ソースファイルは UTF-8 で記述されています。
X68000 上でビルドする際には、UTF-8 から Shift_JIS への変換が必要です。

### u8tosj を使用する方法

あらかじめ、[u8tosj](https://github.com/kg68k/u8tosj) をビルドしてインストールしておいてください。

トップディレクトリで make を実行してください。以下の処理が行われます。
1. build ディレクトリの作成。
2. si.txt を Shift_JIS に変換して build/ へ保存。
3. src/ 内の各ファイルを Shift_JIS に変換して build/ へ保存。

次に、カレントディレクトリを build/ に変更し、make を実行してください。
実行ファイルが作成されます。

### u8tosj を使用しない方法

ファイルを適当なツールで適宜 Shift_JIS に変換してから make を実行してください。
UTF-8 のままでは正しくビルドできませんので注意してください。


## Author
原著作者: M.Satake 氏および BEL. 氏  

改造版作者: TcbnErik / 立花@桑島技研 https://github.com/kg68k/si-ee

