{ pkgs
, packageSets ? [ ]
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
  ripgrep
  stylua
  tmux
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
++ additionalPackages
