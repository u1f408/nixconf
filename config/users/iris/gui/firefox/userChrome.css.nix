{ profile }:

''
  #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
    opacity: 0;
    pointer-events: none;
  }

  #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
    visibility: collapse !important;
  }

  /* Hide splitter, when using Tree Style Tab. */
  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] + #sidebar-splitter {
      display: none !important;
  }

  /* Hide sidebar header, when using Tree Style Tab. */
  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
      visibility: collapse;
  }

  #back-button { display: none !important }
  #forward-button { display: none !important }
  #urlbar-search-mode-indicator { display: none !important }
  #urlbar *|input::placeholder { opacity: 0 !important; }
  #urlbar { text-align: center; }
  #urlbar-container { width: 50vw !important; }
  #star-button { display: none; }
  #navigator-toolbox { border: none !important; }
  .titlebar-spacer { display: none !important; }

  #urlbar:not(:hover):not([breakout][breakout-extend]) > #urlbar-background {
    box-shadow: none !important;
  }

  .urlbar-icon, #userContext-indicator, #userContext-label {
    fill: transparent !important;
    background: transparent !important;
    color: transparent !important;
  }

  #nav-bar-customization-target > toolbarspring { max-width: none !important }

  #urlbar:hover .urlbar-icon, #urlbar:active .urlbar-icon, #urlbar[focused] .urlbar-icon {
    fill: var(--toolbar-color) !important;
  }

  #urlbar-container {
     -moz-box-pack: center !important;
  }
''
