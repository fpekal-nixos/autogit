{ pkgs, config, lib, head, tail, ... }:

{
	options = with lib; {
		services.autogit = {
			enable = mkOption {
				default = false;
				description = "Whether autogit should be running";
				example = true;
				type = types.bool;
			};

			user = mkOption {
				description = "Who is the owner of git repositories. git doesn't like when another user owns them";
				example = "john";
				type = types.str;
			};

			repositories = mkOption {
				default = [];
				description = "List of repositories that should be tracked";
				example = [
					{
						path = "/home/user/dev/proj";
						push = false;
						minutes = 60;
					}
					{
						path = "/srv/game-servers";
						push = true;
						minutes = 180;
					}
				];
				type = types.anything;
			};
		};
	};


	config =
	let
		cfg = config.services.autogit;

		package = pkgs.autogit;

		prepareConfig = list:
		let
			h = lib.head list;
			t = lib.tail list;
		in
			(toString h.minutes) + " " + (if h.push then "true" else "false") + " " + (toString h.path) + "\n" + (if ((lib.length t) > 0) then (prepareConfig t) else "");
	in
	lib.mkIf cfg.enable {
		environment.etc = {
			"autogit/autogit.conf" = {
				enable = cfg.enable;
				text = prepareConfig cfg.repositories;
			};
		};

		systemd.services = {
			autogit = {
				enable = true;
				script = "${package}/bin/autogit";
				wantedBy = [ "multi-user.target" ];
				serviceConfig = {
					User = cfg.user;
				};
				stopIfChanged = true;
			};
		};
	};
}
