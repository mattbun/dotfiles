{ pkgs
, kubernetes ? false
, docker ? false
, additionalPackages ? [ ]
}:

with pkgs; [
  # base
  asdf-vm
  bat
  cargo # required for rnix lsp
  curl
  delta
  fd
  git
  glow
  jq
  neovim
  ripgrep
  stylua
  tmux
  zsh
]
++ (if kubernetes then [
  # kubernetes
  k9s
  kubectl
  kubectx
  kubernetes-helm
  stern
] else [ ])
++ (if docker then with pkgs; [
  # docker
  docker
  docker-compose
] else [ ])
++ additionalPackages
