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

        public string schedule_mode { get; set; }

        public string day_time { get; set; }
        public string night_time { get; set; }

        public int day_temperature { get; set; }
        public int night_temperature { get; set; }

        public Settings () {
            base ("org.pantheon.redshift");
        }

        public DateTime get_day () {
            var parts = day_time.split (":");
            return new DateTime.local (2016, 11, 15, int.parse (parts[0]), int.parse (parts[1]), 0);
        }

        public void set_day (DateTime d) {
            day_time = "%i:%i".printf (d.get_hour (), d.get_minute ());
        }

        public DateTime get_night () {
            var parts = night_time.split (":");
            return new DateTime.local (2016, 11, 15, int.parse (parts[0]), int.parse (parts[1]), 0);
        }

        public void set_night (DateTime d) {
            night_time = "%i:%i".printf (d.get_hour (), d.get_minute ());
        }

        public void reset_all () {
            this.schema.reset ("schedule-mode");
            this.schema.reset ("day-time");
            this.schema.reset ("night-time");
            this.schema.reset ("day-temperature");
            this.schema.reset ("night-temperature");
        }
    }
 }