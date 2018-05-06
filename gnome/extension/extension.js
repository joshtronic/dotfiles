const Main = imports.ui.main;
let activities = Main.panel.statusArea['activities'];

function enable() {
  activities.container.hide();
}

function disable() {
  activities.container.show();
}

function init(metadata) {

}
