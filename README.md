My dot files.

Install:

```bash
sudo apt install -y git curl wget tmux ripgrep moreutils batcat fzf build-essential

# Install uv
curl -LsSf https://astral.sh | sh

# Install neovim
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Install LSP server for vim and python
npm install -g vim-language-server
npm install -g pyright
uv tool install ruff

# Install vim-plug for neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# My dot files
git clone --depth=1 https://github.com/dynax60/dotfiles.git
mkdir -p ~/.config
cp -Rp dotfiles/{zsh,nvim} ~/.config/

# zsh settings
echo "source \$HOME/.config/zsh/env.zsh" >> ~/.zshrc
echo "source \$HOME/.config/zsh/aliases.zsh" >> ~/.zshrc
```
