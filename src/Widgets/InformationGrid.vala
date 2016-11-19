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
 namespace ElementaryRedshift.Widgets {

    public class InformationGrid : Gtk.Grid {

        Gtk.Label mode_label;
        Gtk.Label temperature_label;
        Gtk.Label period_label;

        public InformationGrid () {
            Object (margin: 12,
                row_spacing: 6,
                column_spacing: 6,
                halign: Gtk.Align.CENTER);
        }

        construct {
            mode_label = new Gtk.Label (Indicator.settings.get_mode_name (Indicator.settings.schedule_mode));
            mode_label.halign = Gtk.Align.START;

            temperature_label = new Gtk.Label (_("Unknown"));
            temperature_label.halign = Gtk.Align.START;

            period_label = new Gtk.Label (_("Unknown"));
            period_label.halign = Gtk.Align.START;

            attach (new Widgets.SettingLabel (_("Mode:")), 0, 0, 1, 1);
            attach (mode_label, 1, 0, 1, 1);
            attach (new Widgets.SettingLabel (_("Temperature:")), 0, 1, 1, 1);
            attach (temperature_label, 1, 1, 1, 1);
            attach (new Widgets.SettingLabel (_("Period:")), 0, 2, 1, 1);
            attach (period_label, 1, 2, 1, 1);

            connect_signals ();
        }

        private void connect_signals () {
            Indicator.controller.temperature_changed.connect (() => {
                temperature_label.label = "%i K".printf (Indicator.controller.temperature);
            });

            Indicator.controller.period_changed.connect (() => {
                period_label.label = Indicator.controller.period;
            });

            Indicator.settings.notify["schedule-mode"].connect (() => {
                mode_label.label = Indicator.settings.get_mode_name (Indicator.settings.schedule_mode);
            });
        }
    }
 }