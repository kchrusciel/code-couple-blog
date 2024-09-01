---
title: oh my zsh
tags: []
id: '3959'
categories:
  - - Java
---

### Instalacja Iterm2

Jeśli posiadacie brew instalacja jest prosta. Wystarczy w terminalu wpisać komendę: `brew cask install iterm2` Jeśli nie posiadacie brew należy pobrać narzędzie ze strony [https://www.iterm2.com/downloads.html](https://www.iterm2.com/downloads.html) i zainstalować je. [https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20-%20Patched.itermcolors](https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20-%20Patched.itermcolors) Zapisać gdzieś plik i go uruchomić. W iTrem2 ustawić nowy motyw (iTerm → preferences → profiles → colors → load presets). Wszytskie tutaj: [https://iterm2colorschemes.com/](https://iterm2colorschemes.com/)

### Instalacja Oh My Zsh

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"` Domyślną skórkę można zmienić w pliku `~/.zshrc` and ustawiając `ZSH_THEME="<WYBRANY THEME>"`. Listę motywów znajdziecie [TUTAJ](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes). W przykładzie wybrany został **agnoster**.

### Instalacja czcionki

Niektóre motywy wymagają instalacji dodatkowych czcionek. Wybrany przez nas **agnoster** również. W tym celu pobieramy czcionkę klikając raw view [https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf](https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf). Po otworzeniu pliku wybieramy "Install Font". Następnie ustawiamy czcionkę w iTerm2 (iTerm → Preferences → Profiles → Text → Change Font).

### Auto suggestions

Dla posiadaczy brew: `brew install zsh-autosuggestions` A następnie dodać do pliku .zshrc: `source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh` Dla osób, które nie posiadają brew w folderze `~/.oh-my-zsh/custom/plugins` należy sklonować poniższe repozytorium: `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions` A następnie w pliku .zshrc dodać `plugins=(zsh-autosuggestions)` Po dokonaniu zmian należy otworzyć nowe okno iTerm2.

### Natural Text Selection

iTerm → Preferences → Profiles → Keys → Load Preset... → Natural Text Editing

### Custom prompt styles

### Syntax highlighting

Dla posiadaczy brew: `brew install` `zsh-syntax-highlighting` A następnie na końcu pliku .zshrc dodać: `source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh` Po dokonaniu zmian należy otworzyć nowe okno iTerm2.