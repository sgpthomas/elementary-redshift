/*-
 * Copyright (c) 2016 Sam Thomas (http://launchpad.net/your-project)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Corentin Noël <tintou@mailoo.org>
 */
namespace ElementaryRedshift {

    public static Plug plug;

    public class Plug : Switchboard.Plug {
        Gtk.Grid main_grid;

        public static Gtk.SizeGroup end_size_group;
        public static Gtk.SizeGroup start_size_group;

        public Plug () {
            Object (category: Category.PERSONAL,
                    code_name: Build.PLUGCODENAME,
                    display_name: _("Redshift"),
                    description: _("Adjusts the color temperature of your screen according to your surroundings"),
                    icon: "redshift");
            plug = this;
        }

        static construct {
            end_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
            start_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
        }

        public override Gtk.Widget get_widget () {
            if (main_grid == null) {
                build_ui ();
            }

            return main_grid;
        }

        public override void shown () {
            
        }

        public override void hidden () {
            
        }

        public override void search_callback (string location) {
            
        }

        // 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior")
        public override async Gee.TreeMap<string, string> search (string search) {
            return new Gee.TreeMap<string, string> (null, null);
        }

        private void build_ui () {
            main_grid = new Gtk.Grid ();
            main_grid.margin = 12;
            main_grid.row_spacing = 12;
            main_grid.column_spacing = 12;
            main_grid.halign = Gtk.Align.CENTER;
            main_grid.hexpand = true;

            var temperature_label = new Gtk.Label (_("Temperature"));
            temperature_label.xalign = 0;
            temperature_label.hexpand = true;
            temperature_label.get_style_context ().add_class ("h4");
            Plug.start_size_group.add_widget (temperature_label);

            var day_temp_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 3000, 7000, 100);
            day_temp_scale.adjustment.value = 6500;
            day_temp_scale.add_mark (6500, Gtk.PositionType.BOTTOM, null);
            day_temp_scale.width_request = 200;
            day_temp_scale.value_pos = Gtk.PositionType.RIGHT;
            Plug.end_size_group.add_widget (day_temp_scale);

            var night_temp_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 3000, 7000, 100);
            night_temp_scale.adjustment.value = 3500;
            night_temp_scale.add_mark (3500, Gtk.PositionType.BOTTOM, null);
            night_temp_scale.width_request = 200;
            night_temp_scale.values_pos = Gtk.PositionType.RIGHT;
            Plug.end_size_group.add_widget (night_temp_scale);

            main_grid.attach (temperature_label, 0, 0, 1, 1);
            main_grid.attach (new SettingLabel (_("Day Temperature:")), 0, 1, 1, 1);
            main_grid.attach (day_temp_scale, 1, 1, 2, 1);
            main_grid.attach (new SettingLabel (_("Night Temperature:")), 0, 2, 1, 1);
            main_grid.attach (night_temp_scale, 1, 2, 2, 1);

            main_grid.show_all ();
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Elementary Redshift plug");
    var plug = new ElementaryRedshift.Plug ();
    return plug;
}