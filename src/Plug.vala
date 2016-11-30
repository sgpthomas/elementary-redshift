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
namespace ElementaryRedshift {

    public static Plug plug;

    public class Plug : Switchboard.Plug {
        public static Services.Settings settings;

        public static Gtk.SizeGroup end_size_group;
        public static Gtk.SizeGroup start_size_group;

        Gtk.LinkButton reset_button;
        Gtk.Box main_box;

        public Plug () {
            Object (category: Category.PERSONAL,
                    code_name: Build.PLUGCODENAME,
                    display_name: _("Redshift"),
                    description: _("Adjusts the color temperature of your screen according to your surroundings"),
                    icon: "redshift",
                    supported_settings: new Gee.TreeMap<string, string?> (null, null));
            supported_settings.set ("redshift", null);
            plug = this;
            settings = new Services.Settings ();
        }

        static construct {
            end_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
            start_size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
        }

        public override Gtk.Widget get_widget () {
            if (main_box == null) {
                build_ui ();
            }

            return main_box;
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

            main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            reset_button = new Gtk.LinkButton (_("Reset to Default"));
            reset_button.margin = 12;
            reset_button.vexpand = true;
            reset_button.halign = Gtk.Align.END;
            reset_button.valign = Gtk.Align.END;

            main_box.add (new Widgets.General ());
            main_box.add (new Widgets.Schedule ());
            main_box.add (new Widgets.Temperature ());
            main_box.add (reset_button);

            main_box.show_all ();

            reset_button.activate_link.connect (() => {
                settings.reset_all ();
                return true;
            });
        }
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Elementary Redshift plug");
    var plug = new ElementaryRedshift.Plug ();
    return plug;
}