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

    public class Temperature : Gtk.Grid {

        public Temperature () {
            Object (margin: 12,
                    row_spacing: 12,
                    column_spacing: 12,
                    halign: Gtk.Align.CENTER);
        }

        construct {
            // header
            var temperature_label = new Gtk.Label (_("Temperature"));
            temperature_label.xalign = 0;
            temperature_label.hexpand = true;
            temperature_label.get_style_context ().add_class ("h4");
            Plug.start_size_group.add_widget (temperature_label);

            // temperature scale for day time
            var day_temp_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 30, 70, 1);
            day_temp_scale.adjustment.value = 65;
            day_temp_scale.add_mark (65, Gtk.PositionType.BOTTOM, null);
            day_temp_scale.value_pos = Gtk.PositionType.RIGHT;
            Plug.end_size_group.add_widget (day_temp_scale);

            // temperature scale for night time
            var night_temp_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 30, 70, 1);
            night_temp_scale.adjustment.value = 35;
            night_temp_scale.add_mark (35, Gtk.PositionType.BOTTOM, null);
            night_temp_scale.value_pos = Gtk.PositionType.RIGHT;
            Plug.end_size_group.add_widget (night_temp_scale);

            // attach things to the grid
            attach (temperature_label, 0, 0, 1, 1);
            attach (new SettingLabel (_("Day Temperature:")), 0, 1, 1, 1);
            attach (day_temp_scale, 1, 1, 1, 1);
            attach (new SettingLabel (_("Night Temperature:")), 0, 2, 1, 1);
            attach (night_temp_scale, 1, 2, 1, 1);

            // format slider values
            day_temp_scale.format_value.connect ((val) => {
                return " %.f00 K".printf (val);
            });

            night_temp_scale.format_value.connect ((val) => {
                return " %.f00 K".printf (val);
            });
        }
    }
 }

