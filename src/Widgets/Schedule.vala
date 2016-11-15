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

    public class Schedule : Gtk.Grid {

        public Schedule () {
            Object (margin: 12,
                    row_spacing: 12,
                    column_spacing: 12,
                    halign: Gtk.Align.CENTER);
        }

        construct {
            // header
            var schedule_label = new Gtk.Label (_("Schedule"));
            schedule_label.xalign = 0;
            schedule_label.hexpand = true;
            schedule_label.get_style_context ().add_class ("h4");
            Plug.start_size_group.add_widget (schedule_label);

            // automatic switch
            var auto_switch = new Gtk.Switch ();
            auto_switch.halign = Gtk.Align.START;
            auto_switch.margin_end = 8;
            // Plug.end_size_group.add_widget (auto_switch);

            var help_icon = new Gtk.Image.from_icon_name ("help-info-symbolic", Gtk.IconSize.BUTTON);
            help_icon.halign = Gtk.Align.START;
            help_icon.hexpand = true;
            help_icon.tooltip_text = _("Will automatically use your location to adjust the screen based on day and night cycles.");

            // attach things
            attach (schedule_label, 0, 0, 1, 1);
            attach (new SettingLabel (_("Use location:")), 0, 1, 1, 1);
            attach (auto_switch, 1, 1, 1, 1);
            attach (help_icon, 2, 1, 1, 1);
        }
        
    }
 }