### flutter_widget_exploration

+

+A Flutter application demonstrating interactive and animated UI patterns: a drag & drop color match
game, a swipe-to-manage task list, and a loading dots animation.

+

+---

+

+### Overview

+

+This app includes three focused examples. Each section explains the goal, the building blocks used,
and the core logic, with a GIF preview and a link to the source file.

+

+---

+

+### 1) Drag & Drop Color Match ("Balls" game)

+

+Match colored balls to their corresponding containers using drag and drop.

+

+![Drag & Drop Color Match](assets/gif/interactive_phyics_list.gif)

+

+- **Source**: `lib/interactive_physics_widget.dart`
+- **Key widgets & APIs**: `Draggable`, `DragTarget`, `AnimatedContainer`, `Random`, `setState`
+- **How it works**:

+
    - The available colors are defined once; on each round `randomizeGame()` shuffles both the balls
      and the container order using `Random()` and resets a `matched` map.
+
    - Each ball is a `Draggable<Color>`; while dragging, a semi-transparent `feedback` is shown and
      the original is dimmed via `childWhenDragging`.
+
    - Each container is a `DragTarget<Color>` that reacts to hover with an `AnimatedContainer` (
      border and background hints). `onWillAccept` prevents dropping into an already matched slot.
+
    - In `onAccept`, we compare the dropped `Color` with the container’s expected color; on a match,
      we mark `matched[color] = true` and hide the ball; otherwise we show a hint message.
+
    - When all entries in `matched` are true, a completion banner and a restart button appear to
      re-shuffle the game state.
+

+---

+

+### 2) Interactive Task List (Dismiss + Reorder)

+

+Manage tasks with swipe-to-delete, undo, checkboxes, and drag-to-reorder.

+

+![Interactive Task List](assets/gif/interactive_dismissable_list.gif)

+

+- **Source**: `lib/interactive_dismissable_list.dart`
+- **Key widgets & APIs**: `Dismissible`, `SnackBar` (with undo), `AlertDialog` (confirm),
`ReorderableListView.builder`, `ReorderableDragStartListener`, `Checkbox`
+- **How it works**:

+
    - Tasks and completion state are stored in parallel lists: `_tasks` and `_checked`.
+
    - Each row is wrapped in `Dismissible` with `DismissDirection.endToStart`. Before deletion,
      `confirmDismiss` opens an `AlertDialog` to confirm.
+
    - On delete, we keep a copy of the removed task/index to enable an undo via `SnackBarAction`;
      pressing Undo reinserts the task and its previous checked state.
+
    - The list supports drag-and-drop reordering using `ReorderableListView.builder`; `onReorder`
      updates both `_tasks` and `_checked` in sync. The drag handle is provided by
      `ReorderableDragStartListener`.
+
    - Toggling `Checkbox` updates `_checked[index]`. Completed tasks render with a line-through
      style.
+

+---

+

+### 3) Loading Dots Animation (Staggered)

+

+Three dots animate in a loop with staggered scale and fade.

+

+![Loading Animation](assets/gif/loading_animation.gif)

+

+- **Source**: `lib/loading_animation.dart`
+- **Key widgets & APIs**: `AnimationController`, `AnimatedBuilder`, `CurvedAnimation`, `Interval`,
`Transform.scale`, `Opacity`, `SingleTickerProviderStateMixin`
+- **How it works**:

+
    - A single `AnimationController` repeats every 1200ms. For each dot, we derive two tweens (scale
      and opacity) driven by a `CurvedAnimation` with an `Interval` offset by `index * 0.2` to
      create a staggered effect.
+
    - Inside `AnimatedBuilder`, a `Row` generates three circular `Container` dots that read the
      current values and rebuild smoothly without managing multiple controllers.
+
    - The widget disposes the controller in `dispose()` to avoid leaks.
+

+---

+

+### Navigation

+

+Use the bottom navigation bar to switch between the three screens.

+

+- **Source**: `lib/main.dart`
+- Tabs: Physics (color match), Tasks (dismiss + reorder), Loading (dots animation)

+

+---

+

+### Resources

+

+- **Flutter Widget Catalog**: https://docs.flutter.dev/ui/widgets/catalog
+- **Draggable / DragTarget**: https://api.flutter.dev/flutter/widgets/Draggable-class.html
+- **Dismissible**: https://api.flutter.dev/flutter/widgets/Dismissible-class.html
+- **ReorderableListView**: https://api.flutter.dev/flutter/material/ReorderableListView-class.html
+- **AnimatedBuilder**: https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html