function toggleKCalc() {
  let window = workspace
    .windowList()
    .find((w) => w.resourceClass === "org.kde.kcalc");

  if (window) {
    if (workspace.activeWindow === window) {
      window.minimized = true;
    } else {
      workspace.activeWindow = window;
    }
  } else {
    callDBus(
      "org.user.KCalcLauncher",
      "/org/user/KCalcLauncher",
      "org.user.KCalcLauncher",
      "Launch",
    );
  }
}

registerShortcut("KCalcToggle", "Toggle KCalc", "XF86Calculator", toggleKCalc);
