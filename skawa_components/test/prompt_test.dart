@Tags(const ['aot'])
@TestOn('browser')
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:skawa_components/prompt/prompt.dart';
import 'package:test/test.dart';
import 'package:pageloader/html.dart';
import 'package:pageloader/src/annotations.dart';

void main() {
  tearDown(disposeAnyRunningTest);
  final testBed = new NgTestBed<PromptTestComponent>();
  NgTestFixture<PromptTestComponent> fixture;
  TestPO pageObject;
  group('Prompt |', () {
    setUp(() async {
      fixture = await testBed.create();
      pageObject = await fixture.resolvePageObject/*<TestPO>*/(TestPO);
    });
    test('initialization', () async {
      expect(pageObject.prompt, isNotNull);
    });

    test('displays a message', () async {
      await fixture.query<SkawaPromptComponent>((debugElement) {
        return debugElement.componentInstance is SkawaPromptComponent;
      }, (SkawaPromptComponent component) {
        expect((component.messageText.nativeElement as Element).innerHtml, 'Should you?');
      });
    });

    test('calls yes function', () async {
      await fixture.query<SkawaPromptComponent>((debugElement) {
        return debugElement.componentInstance is SkawaPromptComponent;
      }, (SkawaPromptComponent component) {
        component.yesNoButtonsComponent.yesButton.handleClick(new MouseEvent('test'));
      });
      String msg = await pageObject.messageSpan.innerText;
      expect(msg, 'Yes');
    });

    test('calls no function', () async {
      await fixture.query<SkawaPromptComponent>((debugElement) {
        return debugElement.componentInstance is SkawaPromptComponent;
      }, (SkawaPromptComponent component) {
        component.yesNoButtonsComponent.noButton.handleClick(new MouseEvent('test'));
      });
      String msg = await pageObject.messageSpan.innerText;
      expect(msg, 'No');
    });

    test('modal disappears after clicking yes or no if we want it to', () async {
      await fixture.query<SkawaPromptComponent>((debugElement) {
        return debugElement.componentInstance is SkawaPromptComponent;
      }, (SkawaPromptComponent component) {
        component.yesNoButtonsComponent.noButton.handleClick(new MouseEvent('test'));
      });
      await fixture.query<SkawaPromptComponent>((debugElement) {
        return debugElement.componentInstance is SkawaPromptComponent;
      }, (SkawaPromptComponent component) {
        expect((component.messageText.nativeElement as Element).ownerDocument.querySelector('.pane.modal').classes,
            isNot(contains('visible')));
      });
    });
  });
}

@Component(
    selector: 'test',
    directives: const [SkawaPromptComponent],
    template: '''
  <skawa-prompt [message]="message" [yes]="yesCallback" [no]="noCallback" [visible]="isVisible"></skawa-prompt>
  <span #messageSpan></span>
  ''',
    providers: const [popupBindings])
class PromptTestComponent {
  @ViewChild('messageSpan')
  ElementRef messageSpan;

  void changeText(String input) => (messageSpan.nativeElement as SpanElement).innerHtml = input;

  void yesCallback() {
    changeText('Yes');
    isVisible = false;
  }

  void noCallback() {
    changeText('No');
    isVisible = false;
  }

  final String message = 'Should you?';

  bool isVisible = true;
}

@EnsureTag('test')
class TestPO {
  @ByTagName('skawa-prompt')
  PageLoaderElement prompt;

  @ByTagName('span')
  PageLoaderElement messageSpan;
}
