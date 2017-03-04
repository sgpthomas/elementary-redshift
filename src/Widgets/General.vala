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

    public class General : Gtk.Grid {

        Gtk.Switch redshift_switch;
        Gtk.Switch indicator_switch;

        public General () {
            Object (margin: 12,
                    row_spacing: 12,
                    column_spacing: 12,
                    halign: Gtk.Align.CENTER);
        }

        construct {
            // header
            var general_label = new Gtk.Label (_("General"));
            general_label.xalign = 0;
            general_label.hexpand = true;
            general_label.get_style_context ().add_class ("h4");
            Plug.start_size_group.add_widget (general_label);

            // redshift
            redshift_switch = new Gtk.Switch ();

            // indicator
            indicator_switch = new Gtk.Switch ();

            attach (general_label, 0, 0, 1, 1);
            attach (new SettingLabel (_("Active:")), 0, 1, 1, 1);
            attach (redshift_switch, 1, 1, 1, 1);
            attach (new SettingLabel (_("Show indicator:")), 0, 2, 1, 1);
            attach (indicator_switch, 1, 2, 1, 1);

            Plug.settings.schema.bind ("active", redshift_switch, "active", SettingsBindFlags.DEFAULT);
            Plug.settings.schema.bind ("indicator", indicator_switch, "active", SettingsBindFlags.DEFAULT);
        }
    }
}