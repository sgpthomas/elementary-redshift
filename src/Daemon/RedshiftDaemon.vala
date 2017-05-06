/*-
 * Copyright (c) 2016 Sam Thomas (https://github.com/sgpthomas/elementary-redshift)
 *
 * This is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Sam Thomas <sgpthomas@gmail.com>
 */
namespace ElementaryRedshift.Daemon {

	public class RedshiftController : GLib.Application {

		Services.Settings settings;
		Child child;

		Subprocess process;
		// Pid child_pid;

		public RedshiftController () {
			Object (application_id: "org.pantheon.redshift.daemon", flags: ApplicationFlags.FLAGS_NONE);
			set_inactivity_timeout (1000);
		}

		~RedshiftController () {
			release ();
		}

		public override void startup () {
			message ("Redshift Daemon Started");
			base.startup ();

			settings = new Services.Settings ();
			child = new Child (settings);

			connect_signals ();

			hold ();

			settings.active = true;

			Timeout.add (1000, child.get_info);

            // install signal handler
            Unix.signal_add (ProcessSignal.INT, (SourceFunc) signal_handler);
		}

		public override void activate () {
			message ("Redshift Daemon Activated");
		}

		public override bool dbus_register (DBusConnection connection, string object_path) throws Error {
			return true;
		}

        public bool signal_handler () {
			message ("Redshift Daemon Exiting");
			settings.active = false;
			child.terminate ();
            Process.exit (0);
        }

		private void execute (string[] options) {

			// kill old processes if any exist
			if (process != null) {
				process.send_signal (ProcessSignal.INT);
			}

			string [] spawn_args = {"redshift"};
			foreach (string o in options) {
				spawn_args += o;
			}

			try {
				var launcher = new SubprocessLauncher (SubprocessFlags.STDOUT_PIPE);

				launcher.set_cwd ("/usr/bin/");
				launcher.set_environ (Environ.get ());

				process = launcher.spawnv (spawn_args);

				// child_pid = int.parse (process.get_identifier ());
			} catch (Error e) {
				error ("Error: %s", e.message);
			}
		}

		public void set_temperature (int t) {
			message ("Settings Temperature to %i", t);
			execute ({"-O", t.to_string ()});
		}

		public void connect_signals () {
			settings.notify["active"].connect (() => {
					if (settings.active) {
						set_temperature (settings.temperature);
					} else {
						execute ({"-x"});
					}
				});

			settings.notify["temperature"].connect (() => {
					set_temperature (settings.temperature);
				});
		}

	}

	public static int main (string[] args) {
		var app = new RedshiftController ();

		// register the daemon
		try {
			app.register ();
		} catch (Error e) {
			error ("Unable to register redshift daemon");
		}

		// run
		return app.run (args);
	}
}