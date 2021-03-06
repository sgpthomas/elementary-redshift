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

    public class Settings : Granite.Services.Settings {

        public bool active { get; set; }
        public bool indicator { get; set; }

        public string schedule_mode { get; set; }

        public int day_time { get; set; }
        public int night_time { get; set; }

        public int day_temperature { get; set; }
        public int night_temperature { get; set; }

		public int temperature { get; set; }
		public string period { get; set; }

        public Settings () {
            base ("com.github.sgpthomas.elementary-redshift");
        }

        public DateTime get_day () {
			var min = day_time % 100;
			var hour = (day_time - min) / 100;
            return new DateTime.local (2016, 11, 15, hour, min, 0);
        }

        public void set_day (DateTime d) {
            day_time = (100 * d.get_hour ()) + d.get_minute ();
        }

        public DateTime get_night () {
			var min = night_time % 100;
			var hour = (night_time - min) / 100;
            return new DateTime.local (2016, 11, 15, hour, min, 0);
        }

        public void set_night (DateTime d) {
            night_time = (100 * d.get_hour ()) + d.get_minute ();
        }

        public string get_mode_name (string mode) {
            switch (mode) {
                case "none":
                    return _("None");
                case "auto":
                    return _("Auto");
                case "custom":
                    return _("Custom");
                default:
                    return _("None");
            }
        }

        public void reset_all () {
            this.schema.reset ("schedule-mode");
            this.schema.reset ("day-time");
            this.schema.reset ("night-time");
            this.schema.reset ("day-temperature");
            this.schema.reset ("night-temperature");
			this.schema.reset ("temperature");
			this.schema.reset ("period");
        }
    }
 }