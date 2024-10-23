{ inputs
, config
, lib
, pkgs
, pkgs-unstable
, devenv_root
, ...
}:
let
  inherit (inputs.caprinix-settings.lib) vscode;

  cfg = config.editors.vscode;
in
{
  options.editors.vscode = {
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

  config = lib.mkIf cfg.enable (
    let
      finalExtensions = cfg.extensions ++ (vscode.helper.getCombinedMixinExtensions (cfg.mixins ++ [ "base" ]));
      finalExtensionPachages = map (mixin: vscode.helper.extensionStringToPackage pkgs-unstable mixin) finalExtensions;
      finalSettings = vscode.helper.mergeSettings [ (vscode.helper.getCombinedMixinSettings (cfg.mixins ++ [ "base" ])) cfg.settings ];

      settingsFormat = pkgs.formats.json { };
      file = settingsFormat.generate "settings.json" finalSettings;
    in
    {
      packages = with pkgs-unstable; [
        (vscode-with-extensions.override {
          vscode = cfg.package;
          vscodeExtensions = finalExtensionPachages;
        })
      ];

      enterShell = ''
        mkdir -p ${config.env.DEVENV_ROOT}/.vscode
        cat ${file} > ${config.env.DEVENV_ROOT}/.vscode/settings.json
      '';

      devcontainer.settings.customizations.vscode.extensions = lib.mkIf cfg.overrideInDevcontainer finalExtensions;
    }
  );
} 
