import 'package:angular2/core.dart';

import 'card_directives.dart';
import 'card_actions_component.dart';

import '../../util/attribute.dart' as attr_util;

/// __Inputs__:
///   - `no-shadow`: will not add default shadow
@Component(
  selector: 'skawa-card',
  template: '<ng-content></ng-content>',
  styleUrls: const ['card_component.css'],
)
class SkawaCardComponent {
  @ContentChild(SkawaCardHeaderComponent)
  SkawaCardHeaderComponent cardHeader;

  @ContentChild(SkawaCardContent)
  SkawaCardContent cardContent;

  get hasHeader => cardHeader != null;
}

/// Content area for cards
///
/// __Inputs:__
///   - `collapsed` -- Initial state of the component will be collapsed
///
/// __Example:__
///
///     <skawa-card-content collapsed>
///         Some content that is collapsed by default.
///     </skawa-card-content>
@Component(
    selector: 'skawa-card-content',
    template: '<ng-content></ng-content>',
    inputs: const ['collapsed'],
    styleUrls: const ['card_content_component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SkawaCardContent {
  final SkawaCardComponent parentCard;

  @HostBinding('class.with-header')
  bool get withHeader => parentCard.hasHeader;

  SkawaCardContent(this.parentCard);

  var collapsed;

  @HostBinding('class.skawa-collapsed')
  bool get isCollapsed {
    return attr_util.isPresent(collapsed);
  }

  /// Toggle collapsed state content area
  void toggle() {
    collapsed = attr_util.toggleAttribute(collapsed);
  }
}

/// Header component for a [SkawaCardComponent]
///
/// __Example:__
///
///     <skawa-card>
///       <skawa-card-header statusColor="rgb(255,0,0)">
///
///       </skawa-card-header>
///     </skawa-card>
@Component(
  selector: 'skawa-card-header',
  template: '<ng-content></ng-content>',
  styleUrls: const ['card_header_component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class SkawaCardHeaderComponent {
  @ContentChild(SkawaCardHeaderTitle)
  SkawaCardHeaderTitle title;

  @ContentChild(SkawaCardHeaderSubhead)
  SkawaCardHeaderSubhead subhead;

  @ContentChild(SkawaCardHeaderImage)
  SkawaCardHeaderImage image;

  @ContentChild(SkawaCardActionsComponent)
  SkawaCardActionsComponent headerActions;

  @HostBinding('class.with-title-image')
  bool get withTitleImage => image != null;

  @HostBinding('class.with-subhead')
  bool get withSubHead => subhead != null;

  @HostBinding('class.with-actions')
  bool get hasActions => headerActions != null;

  /// Status color for the card
  ///
  /// Must be provided in rgb() or rgba() format, hex values are
  /// not picked up.
  @Input()
  String statusColor = 'transparent';

  @Input()
  String backgroundColor = '';

  @HostBinding('style.box-shadow')
  String get statusStyle {
    // if set to null remove styling
    if (statusColor == null) {
      return null;
    }
    // if matches rgb() or rgba() format, use it
    if (_rgbaRegexp.hasMatch(statusColor)) {
      return 'inset 0 4px 0 0 $statusColor';
    }
    return null;
  }

  static final RegExp _rgbaRegexp = new RegExp(r'rgba?\s*\((?:\d+(?:\.[\d]+)?,?\s*){3,4}\)');
}
