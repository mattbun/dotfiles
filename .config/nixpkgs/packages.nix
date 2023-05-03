{ pkgs
, packageSets ? [ ]
, additionalPackages ? [ ]
}:

with pkgs; [
  # base
  asdf-vm
  bat
  curl
  delta
  fd
  git
  glow
  gnutar
  gzip
  jq
  ripgrep
  rnix-lsp
  stylua
  sumneko-lua-language-server
  tmux
  unzip
  zsh
]
++ (if builtins.elem "kubernetes" packageSets then [
  # kubernetes
  k9s
  kubectl
  kubectx
  kubernetes-helm
  stern
] else [ ])
++ (if builtins.elem "docker" packageSets then [
  # docker
  docker
  docker-compose
] else [ ])
++ (if builtins.elem "graphical" packageSets then [
  # graphical
  alacritty
  hack-font
] else [ ])
++ additionalPackages
