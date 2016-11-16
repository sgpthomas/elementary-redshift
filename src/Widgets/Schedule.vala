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

        Gtk.StackSwitcher mode;
        Gtk.Stack stack;
        
        Granite.Widgets.TimePicker daytime;
        Granite.Widgets.TimePicker nighttime;

        public Schedule () {
            Object (margin: 12,
                    // row_spacing: 12,
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

            // mode: none
            var mode_none_label = new Gtk.Label (_("Don't turn on automatically."));
            mode_none_label.wrap = true;
            mode_none_label.justify = Gtk.Justification.CENTER;

            // mode: automatic
            var mode_auto_label = new Gtk.Label (_("Automatically use location to adjust the\nscreen temperature based on the time of day."));
            mode_auto_label.wrap = true;
            mode_auto_label.justify = Gtk.Justification.CENTER;

            // mode: custom
            var mode_custom_label = new Gtk.Label (_("Use custom schedule."));
            mode_custom_label.wrap = true;
            mode_custom_label.justify = Gtk.Justification.CENTER;

            daytime = new Granite.Widgets.TimePicker ();
            Plug.end_size_group.add_widget (daytime);
            nighttime = new Granite.Widgets.TimePicker ();
            Plug.end_size_group.add_widget (nighttime);

            var mode_custom_grid = new Gtk.Grid ();
            mode_custom_grid.margin = 12;
            mode_custom_grid.row_spacing = 12;
            mode_custom_grid.column_spacing = 12;
            mode_custom_grid.halign = Gtk.Align.CENTER;
            mode_custom_grid.attach (new SettingLabel (_("Day starts:")), 0, 0, 1, 1);
            mode_custom_grid.attach (daytime, 1, 0, 1, 1);
            mode_custom_grid.attach (new SettingLabel (_("Night starts:")), 0, 1, 1, 1);
            mode_custom_grid.attach (nighttime, 1, 1, 1, 1);

            stack = new Gtk.Stack ();
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            stack.add_titled (mode_none_label, "none", _("None"));
            stack.add_titled (mode_auto_label, "auto", _("Auto"));
            stack.add_titled (mode_custom_grid, "custom", _("Custom"));

            mode = new Gtk.StackSwitcher ();
            mode.margin_top = 12;
            mode.halign = Gtk.Align.CENTER;
            mode.set_stack (stack);

            // attach things
            attach (schedule_label, 0, 0, 1, 1);
            attach (mode, 0, 1, 1, 1);
            attach (stack, 0, 2, 1, 1);

            this.show_all ();

            connect_signals ();
            update ();
        }

        private void connect_signals () {
            stack.notify["visible-child"].connect (() => {
                settings.schedule_mode = stack.visible_child_name;
                message (stack.visible_child_name);
            });

            daytime.time_changed.connect (() => {
                settings.set_day (daytime.time);
            });

            nighttime.time_changed.connect (() => {
                settings.set_night (nighttime.time);
            });

            settings.changed.connect (() => {
                update ();
            });
        }

        private void update () {
            stack.set_visible_child_name (settings.schedule_mode);

            daytime.time = settings.get_day ();
            nighttime.time = settings.get_night ();
        }
        
    }
 }