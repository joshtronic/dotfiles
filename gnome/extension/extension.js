const Config = imports.misc.config;
const ExtensionUtils = imports.misc.extensionUtils;
const Main = imports.ui.main;
const SessionMode = imports.ui.sessionMode;

const disableHotCorners = function () {
  Main.layoutManager.hotCorners.forEach(function (hotCorner) {
    if (!hotCorner) return;
    hotCorner._toggleOverview = function () {};
    hotCorner._pressureBarrier._trigger = function () {};
  });
};

let activities;
let centerBox;
let children;
let dateMenu;
let hotCornerCallback;
let rightBox;

function enable() {
  // Hides the activities button
  activities = Main.panel.statusArea['activities'];
  activities.container.hide();

  // Disables the activities hot corner
  disableHotCorners();
  hotCornerCallback = Main.layoutManager.connect('hot-corners-changed', disableHotCorners);

  // Moves the clock to the right
  if (Main.sessionMode.panel.center.indexOf('dateMenu') > -1) {
    centerBox = Main.panel._centerBox;
    rightBox = Main.panel._rightBox;
    dateMenu = Main.panel.statusArea.dateMenu;
    children = centerBox.get_children();

    if (children.indexOf(dateMenu.container) > -1) {
      centerBox.remove_actor(dateMenu.container);
      children = rightBox.get_children();
      rightBox.insert_child_at_index(dateMenu.container, children.length - 1);
    }
  }
}

function disable() {
  // Shows the activities button
  activities.container.show();

  // Enables the activities hot corner
  Main.layoutManager.disconnect(hotCornerCallback);
  Main.layoutManager._updateHotCorners();

  // Moves the clock to the center
  if (Main.sessionMode.panel.center.indexOf('dateMenu') > -1) {
    centerBox = Main.panel._centerBox;
    rightBox = Main.panel._rightBox;
    dateMenu = Main.panel.statusArea.dateMenu;
    children = rightBox.get_children();

    if (children.indexOf(dateMenu.container) > -1) {
      rightBox.remove_actor(dateMenu.container);
      centerBox.add_actor(dateMenu.container);
    }
  }
}

function init() { }
