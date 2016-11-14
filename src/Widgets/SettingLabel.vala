public class SettingLabel : Gtk.Label {
    public SettingLabel (string label) {
        Object (label: label);
    }

    construct {
        halign = Gtk.Align.END;
        margin_start = 12;
    }
}