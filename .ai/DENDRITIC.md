Getting Started
Usage (for existing flake-parts setups)
Add the dendrix input to your flake:

# flake.nix -- add the dendrix input:
{
  inputs.dendrix.url = "github:vic/dendrix";

  # Flatten dependencies.
  #inputs.dendrix.inputs.import-tree.follows = "import-tree";
  #inputs.dendrix.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
}
Then import Dendrix trees/layers on any flake-parts module of yours:

{ inputs, ... }:
{
  imports = [
    # inputs.dendrix.vic-vix.macos-keys # example <macos-keys> aspect.
    # inputs.dendrix.vix # example layer, see https://github.com/vic/dendrix/tree/main/dev/layers
  ];
}
See usage instructions for either Dendrix Trees or Dendrix Layers.

Quick Start (for NixOS newcomers)
Dendrix is a work in progress. We aim to provide batteries-included preconfigured NixOS experience for newcomers. But we are currently working on it.

We provide some templates you can use to start a new system flake.

nix flake init github:vic/dendrix#template
Then edit your layers.nix file.

Try it Online!
If you are not currently a NixOS user, you can try running an ephemereal NixOS on the web.

Go to Distrosea nixos-unstable-minimal
Start a machine and run the following:

nix run .#os-switch template

Customization
Once you have a ./modules/ directory on your flake, just add flake-parts modules following the dendritic pattern. All files will be loaded automatically. Edit your layers.nix to include dendrix provided aspects you choose.


Dendritic Nix Dendritic is a pattern for writing nix configurations based on flake-parts's modules option. We say that Dendritic nix configurations are aspect-oriented, meaning that each nix file provides config-values for the same aspect across different nix configuration classes. This is done via flake-parts' flake.modules.<class>.<aspect> options. Where <class> is a type of configuration, like nixos, darwin, homeManager, nixvim, etc. And <aspect> is the cross-cutting concern or feature that is being configured across one or more of these classes. Example of a dendritic configuration. As an example of what a dendritic nix config looks like, suppose we want to configure ssh facilities (the ssh aspect) across our NixOS, Nix-darwin hosts and user homes. # modules/ssh.nix -- like every other file inside modules, this is a flake-parts module. { config, ... }: { flake.modules.nixos.ssh = { # Linux config: server, firewall-ports, etc. }; flake.modules.darwin.ssh = { # MacOS config: enable builtin ssh server, etc. }; flake.modules.homeManager.ssh = { # setup ~/.ssh/config or keys. }; perSystem = {pkgs, ...}: { # expose custom package/checks/devshells by this aspect. }; } That's it. This is what Dendritic is all about. By following this configuration pattern you will notice your code now incorporates the following: Denritic Advantages No need to use specialArgs for communicating values. A common pattern for passing values between different nix configurations types (e.g., between a nixos config and a homeManager one), is to use the specialArgs module argument or home-manager.extraSpecialArgs. This is considered an anti-pattern in dendritic setups, since there's no need to use specialArgs at all. Because you can always use let bindings (or even define your own options at the flake-parts level) to share values across different configuration classes. # modules/vic.nix -- a flake-parts module that configures the "vic" user aspect. let userName = "vic"; # a shared value between classes in { flake.modules.nixos.${userName} = { users.users.${userName} = { isNormalUser = true; extraGroups = [ "wheel" ]; }; }; flake.modules.darwin.${userName} = { system.primaryUser = userName; # configuring a user is different on MacOS than on NixOS. }; flake.modules.homeManager.${userName} = { pkgs, lib, ... }: { home.username = lib.mkDefault userName; home.homeDirectory = lib.mkDefault (if pkgs.stdenvNoCC.isDarwin then "/Users/${userName}" else "/home/${userName}"); home.stateVersion = lib.mkDefault "25.05"; }; } No file organization restrictions. The dendritic pattern imposes no restrictions on how you organize or name your nix files. Unlike other nix-configuration libs/frameworks that mandate a predefined structure. In Dendritic, you are free to move or rename each file as it better suits your mental model. This is possible because: All nix files have the same semantic meaning. In a Dendritic setup, each .nix file has only one interpretation: A flake-parts module. Unlike other kinds of setup where each nix file can be a nixos configuration, or a home-manager configuration, or a package, or something entirely different. In such setups, loading a file requires you to know what kind of meaning each file has before importing it. This leads us to having: No manual file imports. All files being flake-parts modules, means we have no need for manually importing nix files. They can all be loaded at once into a single import. The Dendritic community commonly uses vic/import-tree for this. Note: import-tree ignores any file that has an _ anywhere as part of its path. # flake.nix { inputs = { flake-parts.url = "github:hercules-ci/flake-parts"; import-tree.url = "github:vic/import-tree"; # all other inputs your flake needs, like nixpkgs. }; outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules); } This is the only place you will call import-tree and it will load all files under ./modules recursively. This means we can have: Minimal and focused flake.nix Instead of having huge flake.nix files with lots of nix logic inside the flake itself. It is now possible move to all nix logic into ./modules. Your flake becomes minimal, focused on defining inputs and possibly cache, experimental-features config. And any file inside modules can contribute to flake outputs (packages/checks/osConfigurations) as needed. # modules/flake/formatter.nix { perSystem = {pkgs, ...}: { formatter = pkgs.alejandra; }; } Feature Centric instead of Host Centric. As noted by Pol Dellaiera in Flipping the Configuration Matrix: the configuration is now structured around features, not hostnames. It is a shift in the axis of composition, essentially an inversion of configuration control. What may seem like a subtle change at first has profound implications for flexibility, reuse, and maintainability. You will notice that you start naming your files around the aspects (features) they define instead of where they are applied. Feature Closures By closure, we mean: everything that is needed for a given feature to work is configured closely, in the same unit (file/directory named after the feature). Because a single feature.nix contributes to different configuration classes, it has all the information on how feature works, instead of having to look at different files for package definitions, nixos or home-manager configurations dispersed over all over the tree. If you need to look where some feature is defined on a repo you don't know, it will be easier to simply guess by path name. Paths become documentation. Incremental Features Since all nix files are loaded automatically. You can increment the capabilities that an existing feature-x/basic.nix provides by just creating another feature-x/advanced.nix. Both of them should contribute to the same aspect: flake.modules.<class>.feature-x, but each file focuses on the different capabilities they provide to the system whole. This way, you can split feature-x/advanced.nix into more files. And adding or removing files from your modules (or adding an _ for them to be ignored) has no other impact than the overall capabilities provided into your systems. This is an easy way to disable loading files while on a huge refactor. Or when some hosts or features should be decommissioned immediately/temporarily. No dependencies other than flake-parts Since the dendritic pattern builds around flake-parts modules, the only dependency is flake-parts. You can load files using import-tree or any other means. You can also use any flake-parts based library to define your configurations, like Unify, as long as it exposes flake.modules.<class>.<aspect> attribute sets. Dendritic community. Last but not least. By using the dendritic pattern you open the door to defining or re-using existing generic (user/host independent) configurations from the community. This is the goal of the Dendrix project: To allow people share dendritic configurations and socially enhance their capabilities. With this setup, how do I specify a module that is to be consumed by one host and not the other?


