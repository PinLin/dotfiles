# dotfiles

My dotfiles.

## Demo

| `zsh` | `vim` |
| :---: | :---: |
| ![zsh](https://imgur.com/hZlqG8b.png) | ![vim](https://imgur.com/82FL3zs.png) |

| `tmux` |
| :---: |
| ![tmux](https://imgur.com/UkgPhAP.png) |

## Installation

Managed via [yadm](https://yadm.io/).

```sh
# 1. Install yadm
brew install yadm                                                   # macOS
sudo apt install yadm                                               # Debian / Ubuntu (recent)
git clone https://github.com/TheLocehiliosan/yadm.git ~/.yadm-project  # 上面都沒有時 (老 Debian / Synology Entware / etc.)

# 2. Clone
yadm clone https://github.com/PinLin/dotfiles.git
# 老環境若 yadm 是手動 clone 進來的, 用全路徑:
# ~/.yadm-project/yadm clone https://github.com/PinLin/dotfiles.git

# 3. 套用 alternates (對老環境設 class=veryold)
yadm config local.class veryold   # 只在 tmux <2.1 / vim <8 / 之類撐不起現代 stack 的機器需要
yadm alt

# 4. (可選) 跑 bootstrap 確認工具齊全
yadm bootstrap
```
