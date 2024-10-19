{ inputs
, config
, lib
, pkgs
, pkgs-unstable
, devenv_root
, ...
}:
{
  options.vscode = {
    enable = lib.mkEnableOption "vscode editor";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs-unstable.vscode-fhs;
      defaultText = lib.literalExpression "pkgs.vscode-fhs";
      description = "The Vscode package to use";
    };
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      defaultText = lib.literalExpression "[]";
      description = "Which extensions to add to vscode";
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      defaultText = lib.literalExpression "{}";
      description = "settings to add to the workspace";
    };
    mixins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      defaultText = lib.literalExpression "[]";
      description = "Which mixins to add to vscode";
    };
    overrideInDevcontainer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If your extensions should override those defined in devcontainer.settings.customizations.vscode.extensions";
    };
  };
}
  