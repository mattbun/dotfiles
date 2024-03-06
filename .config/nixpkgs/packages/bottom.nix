{ config, lib, pkgs, ... }:

{
  bun.shellScripts = lib.mkIf config.programs.bottom.enable {
    # Custom bottom layouts
    btm-cpu = ''
      btm -C ${pkgs.writeText "cpu.toml" ''
        [[row]]
          [[row.child]]
            type = "cpu"
        [[row]]
          [[row.child]]
            type = "mem"
          [[row.child]]
            type = "net"
          [[row.child]]
            type = "temperature"
        [[row]]
          ratio = 2
          [[row.child]]
            type = "process"
      ''}
    '';

    btm-mem = ''
      btm -C ${pkgs.writeText "mem.toml" ''
        [[row]]
          [[row.child]]
            type = "mem"
        [[row]]
          [[row.child]]
            type = "cpu"
          [[row.child]]
            type = "net"
          [[row.child]]
            type = "temperature"
        [[row]]
          ratio = 2
          [[row.child]]
            type = "process"
      ''}
    '';
  };
}
