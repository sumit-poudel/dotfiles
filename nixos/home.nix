{config, pkgs, inputs,...}:

{
	home.username = "sumit";
	home.homeDirectory = "/home/sumit";
  	home.stateVersion = "25.11";

	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use nixos btw";
				};
				};
	home.packages = with pkgs;[
			bat
			brave
			];
}
