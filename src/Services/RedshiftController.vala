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

        public bool active = false;
        public int temperature = -1;
        public string period = "Unknown";
        public double[] location = { 0.0, 0.0 };

        public signal void active_changed ();
        public signal void temperature_changed ();
        public signal void period_changed ();
        public signal void location_changed ();

        Subprocess process;
        Pid child_pid;

        DataInputStream stdout_pipe;
        uint? monitor_id;

        public RedshiftController () {

            spawn_child ();

            connect_signals ();

            // install signal handler
            Unix.signal_add (ProcessSignal.INT, (SourceFunc) signal_handler);
        }

        private void spawn_child () {
            // kill old processes if any exist
            if (process != null) {
                terminate_child ();
            }

            // remove any old idle functions
            if (monitor_id != null) {
                Source.remove (monitor_id);
            }

            // don't launch a process if mode is none or custom
            if (Indicator.settings.schedule_mode != "auto") {
                return;
            }

            string[] spawn_args = {"redshift", "-v"};
            string[] spawn_env = Environ.get ();

            // set temperature range
            spawn_args += "-t %i:%i".printf (Indicator.settings.day_temperature, Indicator.settings.night_temperature);

            try {
                var launcher = new SubprocessLauncher (SubprocessFlags.STDOUT_PIPE);
                launcher.set_cwd ("/usr/bin/");
                launcher.set_environ (spawn_env);

                process = launcher.spawnv (spawn_args);

                child_pid = int.parse (process.get_identifier ());
                
            } catch (Error e) {
                error ("Error: %s", e.message);
            }
            
            // watch for process exiting
            ChildWatch.add (child_pid, (pid, status) => {
                message ("Redshift exited with status %i", status);
                Process.close_pid (pid);
            });

            // get input stream for stdout pipe
            stdout_pipe = new DataInputStream (process.get_stdout_pipe ());
            monitor_id = Idle.add_full (Priority.LOW, (GLib.SourceFunc) monitor_stream);
        }

        public void terminate_child () {
            process.send_signal (ProcessSignal.INT);
        }

        public bool signal_handler () {
            terminate_child ();
            Process.exit (0);
            return false;
        }

        public void set_active (bool b) {
            if (b && !active) {
                process.send_signal (ProcessSignal.USR1);
            } else if (!b && active) {
                process.send_signal (ProcessSignal.USR1);
            }
        }

        private bool monitor_stream () {

            read_buffer_async.begin ();

            return Source.CONTINUE;
        }

        private async void read_buffer_async () {
            if (stdout_pipe.has_pending ()) {
                return;
            }
            try {
                var line = yield stdout_pipe.read_line_async ();
                if (line != null) {
                    if (line.contains (": ")) {
                        update_property (line);
                    }
                }

            } catch (IOError e) {
                error ("IOError: %s", e.message);
            }
        }

        private void update_property (string ret) {
            var parts = ret.split (": ");

            switch (parts[0]) {
                case "Status":
                    active = (parts[1].strip () == "Enabled");
                    active_changed ();
                    break;
                case "Color temperature":
                    temperature = int.parse (parts[1].replace ("K", ""));
                    temperature_changed ();
                    break;
                case "Period":
                    period = parts[1];
                    period_changed ();
                    break;
                case "Location":
                    var coords = parts[1].split (", ");

                    var a = coords[0].split (" ");
                    if (a[1] == "N" || a[1] == "E") {
                        location[0] = double.parse (a[0]);
                    } else {
                        location[0] = 1 * double.parse (a[0]);
                    }

                    a = coords[1].split (" ");
                    if (a[1] == "N" || a[1] == "E") {
                        location[1] = double.parse (a[0]);
                    } else {
                        location[1] = -1 * double.parse (a[0]);
                    }

                    location_changed ();
                    break;
            }
        }

        private void connect_signals () {
            // active_changed.connect (() => {
            //     message ("active: %s", active.to_string ());
            // });

            // temperature_changed.connect (() => {
            //     message ("t: %i", temperature);
            // });

            // period_changed.connect (() => {
            //     message ("period: %s", period);
            // });

            // location_changed.connect (() => {
            //     message ("location: %f %f", location[0], location[1]);
            // });  
        }
    }
 }