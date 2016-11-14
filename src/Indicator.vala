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

    public class Indicator : Wingpanel.Indicator {
        /* Our display widget, a composited icon */
        private Wingpanel.Widgets.OverlayIcon? display_widget = null;

        /* The main widget that is displayed in the popover */
        private Gtk.Grid? main_grid = null;

        /* Constructor */
        public Indicator () {
            /* Some information about the indicator */
            Object (code_name : Build.INDICATOR_NAME, /* Unique name */
                    display_name : _(Build.INDICATOR_TITLE), /* Localised name */
                    description: _(Build.INDICATOR_DESCRIPTION)); /* Short description */

            /* Indicator should be visible at startup */
            this.visible = true;
        }

        /* This method is called to get the widget that is displayed in the top bar */
        public override Gtk.Widget get_display_widget () {
            /* Check if the display widget is already created */
            if (display_widget == null) {
                /* Create a new composited icon */
                display_widget = new Wingpanel.Widgets.OverlayIcon ("weather-clear-night-symbolic");
            }

            /* Return our display widget */
            return display_widget;
        }

        /* This method is called to get the widget that is displayed in the popover */
        public override Gtk.Widget? get_widget () {
            /* Check if the main widget is already created */
            if (main_grid == null) {
                /* Create the main widget */
                create_grid ();
            }

            /* Return our main widget */
            return main_grid;
        }

        /* This method is called when the indicator popover opened */
        public override void opened () {
            /* Use this method to get some extra information while displaying the indicator */
        }

        /* This method is called when the indicator popover closed */
        public override void closed () {
            /* Your stuff isn't shown anymore, now you can free some RAM, stop timers or anything else... */
        }

        private void create_grid () {
            
        }
    }
 }

/*
* This method is called once after your plugin has been loaded.
* Create and return your indicator here if it should be displayed on the current server.
*/
public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    /* A small message for debugging reasons */
    debug ("Activating Redshift Indicator");

    /* Check which server has loaded the plugin */
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        /* We want to display our sample indicator only in the "normal" session, not on the login screen, so stop here! */
        return null;
    }

    /* Create the indicator */
    var indicator = new ElementaryRedshift.Indicator ();

    /* Return the newly created indicator */
    return indicator;
}