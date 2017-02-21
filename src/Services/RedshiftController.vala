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
 namespace ElementaryRedshift.Services {

    public class RedshiftController {

        public signal void active_changed ();
        public signal void temperature_changed ();
        public signal void period_changed ();
        public signal void location_changed ();

		Child child;
		Thread<bool> info_thread;

		Subprocess process;
		Pid child_pid;

        public RedshiftController () {

			if (info_thread != null) {
				message ("A thread already exists. Kill old one before making a new one.");
				child.running = false;
				info_thread.join ();
			}

			child = new Child ();
			try {
				info_thread = new Thread<bool>.try ("Elementary Redshift Info", child.run);
			} catch (Error e) {
				error ("Error: %s", e.message);
			}

            connect_signals ();

            // install signal handler
            Unix.signal_add (ProcessSignal.INT, (SourceFunc) signal_handler);
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
				var launcher = new SubprocessLauncher (SubprocessFlags.STDOUT_SILENCE);

				launcher.set_cwd ("/usr/bin/");
				launcher.set_environ (Environ.get ());

				process = launcher.spawnv (spawn_args);

				child_pid = int.parse (process.get_identifier ());
			} catch (Error e) {
				error ("Error: %s", e.message);
			}
		}

        public bool signal_handler () {
			child.terminate ();
			child.running = false;
			info_thread.join ();
            Process.exit (0);
        }

		public bool get_active () {
			return Indicator.settings.active;
		}

        public void set_active (bool b) {
			Indicator.settings.active = b;
        }

		public int get_temperature () {
			return Indicator.settings.temperature;
		}

		public void set_temperature (int t) {
			execute ({"-O", t.to_string ()});
		}

		public string get_period () {
			return Indicator.settings.period;
		}

        private void connect_signals () {
			Indicator.settings.notify["active"].connect (() => {
					active_changed ();
				});

			Indicator.settings.notify["temperature"].connect (() => {
					temperature_changed ();
				});

			Indicator.settings.notify["period"].connect (() => {
					period_changed ();
				});

			active_changed.connect (() => {
					bool active = Indicator.settings.active;
					if (active) {
						set_temperature (Indicator.settings.temperature);
					} else {
						execute ({"-x"});
					}
				});

			temperature_changed.connect (() => {
					set_temperature (Indicator.settings.temperature);
				});
        }
    }
 }