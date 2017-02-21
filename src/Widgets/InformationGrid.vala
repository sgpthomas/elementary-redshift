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

		Widgets.SettingLabel mode_setting_label;
		Widgets.SettingLabel temperature_setting_label;

		Widgets.SettingLabel period_setting_label;
        Gtk.Label mode_label;
        Gtk.Label temperature_label;
        Gtk.Label period_label;

		Gtk.Scale temperature_scale;

        public InformationGrid () {
            Object (margin: 12,
                row_spacing: 6,
                column_spacing: 6,
                halign: Gtk.Align.CENTER);
        }

        construct {
			mode_setting_label = new Widgets.SettingLabel (_("Schedule:"));
            mode_label = new Gtk.Label (Indicator.settings.get_mode_name (Indicator.settings.schedule_mode));
            mode_label.halign = Gtk.Align.START;

			temperature_setting_label = new Widgets.SettingLabel (_("Temperature:"));
            temperature_label = new Gtk.Label (_("Unknown"));
            temperature_label.halign = Gtk.Align.START;

			period_setting_label = new Widgets.SettingLabel (_("Period:"));
            period_label = new Gtk.Label (_("Unknown"));
            period_label.halign = Gtk.Align.START;

			temperature_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 30, 70, 1);
			temperature_scale.adjustment.value = Indicator.settings.temperature / 100;
			temperature_scale.value_pos = Gtk.PositionType.TOP;
			temperature_scale.format_value.connect ((val) => {
					return " %.f00 K".printf (val);
				});

            attach (mode_setting_label, 0, 0, 1, 1);
            attach (mode_label, 1, 0, 1, 1);
            attach (temperature_setting_label, 0, 1, 1, 1);
            attach (temperature_label, 1, 1, 1, 1);
            attach (period_setting_label, 0, 2, 1, 1);
            attach (period_label, 1, 2, 1, 1);
			attach (temperature_scale, 0, 3, 2, 1);

            connect_signals ();

			update ();
        }

		private void update () {
			if (Indicator.settings.schedule_mode == "auto" || Indicator.settings.schedule_mode == "custom") {
				temperature_setting_label.no_show_all = false;
				temperature_setting_label.show ();

				temperature_label.no_show_all = false;
				temperature_label.show ();

				period_setting_label.no_show_all = false;
				period_setting_label.show ();

				period_label.no_show_all = false;
				period_label.show ();

				temperature_scale.no_show_all = true;
				temperature_scale.hide ();
			} else {
				temperature_setting_label.no_show_all = true;
				temperature_setting_label.hide ();

				temperature_label.no_show_all = true;
				temperature_label.hide ();

				period_setting_label.no_show_all = true;
				period_setting_label.hide ();

				period_label.no_show_all = true;
				period_label.hide ();

				temperature_scale.no_show_all = false;
				temperature_scale.show ();
				temperature_scale.adjustment.value = (Indicator.settings.temperature / 100);
			}
		}

        private void connect_signals () {
            Indicator.controller.temperature_changed.connect (() => {
					temperature_label.label = "%i K".printf (Indicator.controller.get_temperature ());
				});

            Indicator.controller.period_changed.connect (() => {
					period_label.label = Indicator.controller.get_period ();
				});

            Indicator.settings.notify["schedule-mode"].connect (() => {
					mode_label.label = Indicator.settings.get_mode_name (Indicator.settings.schedule_mode);
					update ();
				});

			temperature_scale.value_changed.connect (() => {
					Indicator.settings.temperature = (int) (temperature_scale.adjustment.value * 100);
				});
        }
    }
 }