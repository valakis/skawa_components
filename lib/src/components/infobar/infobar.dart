import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

/// An Inforbar is compositing an (icon as button)[https://material.io/components/web/catalog/buttons/icon-toggle-buttons/] and
/// an arbitrary component. Infobar is designed to display small notifications, important messages to the user, *in-context*.
///
/// This differs from "snackbars" and "toasts" that serve as feedback of actions.
///
/// *Note:* Infobar component uses Material Icon font, make sure it is available
///
/// __Example usage:__
///     <skawa-infobar [icon]="myIcon" [url]="urlToNavigate"></skawa-infobar>
///     <skawa-infobar [icon]="myIcon" [url]="urlToNavigate"><some-cmp></some-cmp></skawa-infobar>
///
/// __Inputs__:
///
///   - `icon`: Icon to display in the infobar.
///   - `url`: Url to navigate the user to when icon is triggered.
///
/// __Events:__
///
/// - `trigger: Event` -- Published when the `icon` is triggered.
///
@Component(
  selector: 'skawa-infobar',
  templateUrl: 'infobar.html',
  styleUrls: const ['infobar.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [MaterialIconComponent, MaterialButtonComponent],
  inputs: const ['icon', 'url'],
)
class SkawaInfobarComponent {
  // TODO: dismiss

  String icon;

  String url;

  @ViewChild('primaryAction')
  MaterialButtonComponent primaryActionButton;

  @Output()
  Stream<UIEvent> get trigger => primaryActionButton.trigger;

  void navigate() {
    if (url != null) window.location.href = url;
  }
}
