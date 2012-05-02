/*
 * Feedback (for Prototype)
 * version: 0.1 (2009-07-21)
 * @requires Prototype v1.6 or later
 *
 * This script is part of the Feedback Ruby on Rails Plugin:
 *   http://
 *
 * Licensed under the MIT:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2009 Jean-Sebastien Boulanger [ jsboulanger@gmail.com ]
 *
 * Usage:
 *
 *  Feedback.init('feedback_link_tab', {
 *    // options
 *  });
 *
 */

var Feedback;

if(Feedback == undefined) {
  Feedback = {};
  Feedback.init = function(callerSettings) {    // Changes to those default settings might need adjustment in feedback.css
    this.settings = Object.extend({
      tabControl: 'feedback_link',
      main: 'feedback',
      closeLink: 'feedback_close_link',
      modalWindow: 'feedback_modal_window',
      modalContent: 'feedback_modal_content',
      form: 'feedback_form',
      formUrl: '/feedbacks/new',
      overlay: 'feedback_overlay',
      loadingImage: '/assets/feedback/loading.gif',
      loadingText: 'Loading...',
      sendingText: 'Sending...',
      tabPosition: 'left'
    }, callerSettings || {});

    this.settings.feedbackHtml = '<div id="' + this.settings.main + '" style="display: none;">' +
                                   '<div id="' + this.settings.modalWindow + '">' +
                                     '<a href="#" id="' + this.settings.closeLink + '"></a>' +
                                     '<div id="' + this.settings.modalContent + '"></div>' +
                                   '</div>' +
                                 '</div>'
    this.settings.overlayHtml = '<div id="' + this.settings.overlay + '" class="feedback_hide"></div>';
    this.settings.tabHtml = '<a href="#" id="feedback_link" class="' + this.settings.tabControl + ' ' + this.settings.tabPosition + '"></a>';

    if (this.settings.tabPosition != null && $$('#' + this.settings.tabControl).length == 0)
      $$("body").first().insert(this.settings.tabHtml);

    $$('.' + this.settings.tabControl).each(function(e) {
      $(e).observe('click', function() {
        Feedback.loading();
        new Ajax.Updater(Feedback.settings.modalContent, Feedback.settings.formUrl, {
          method: 'get',
          onComplete: function(transport) {
            $(Feedback.settings.form).observe('submit', Feedback.submitFeedback);
          }
        });
        return false;
      });
    });
  }

  Feedback.submitFeedback = function(event){
		$('feedback_page').value = location.href;
    var data = Form.serialize($(Feedback.settings.form));
    var url = $(Feedback.settings.form).action;
    Feedback.loading(Feedback.settings.sendingText);
    new Ajax.Updater(Feedback.settings.modalContent, url, {
      method: 'POST',
      parameters: data,
      onComplete: function(transport){
        if (transport.status >= 200 && transport.status < 300) {
          $(Feedback.settings.modalWindow).fade({
            duration: 2.0,
            afterFinish: function() {
              Feedback.hideFeedback();
            }
          });
        }
        else {
          $(Feedback.settings.form).observe('submit', Feedback.submitFeedback);
        }
      }
    });    Event.stop(event);
  }

  Feedback.initOverlay = function() {
    if ($$('#' + this.settings.overlay).length == 0)
      $$("body").first().insert(this.settings.overlayHtml)

    $(this.settings.overlay).addClassName('feedback_overlayBG');
  }

  Feedback.showOverlay = function() {
    Feedback.initOverlay();
    $(this.settings.overlay).show();
  }

  Feedback.hideOverlay = function() {
    if ($$('#' + this.settings.overlay).length == 0) return false;
      $(this.settings.overlay).remove();
  }

  Feedback.initFeedback = function() {
    if ($$('#' + this.settings.main).length == 0) {
      $$("body").first().insert(this.settings.feedbackHtml);
      $(this.settings.closeLink).observe('click', function(){
        Feedback.hideFeedback();
        return false;
      });
      Feedback.setWindowPosition();
    }
  }

  Feedback.showFeedback = function() {
    Feedback.initFeedback();
    $(this.settings.main).show();
  }

  Feedback.hideFeedback = function() {
    $(this.settings.main).hide();
    $(this.settings.main).remove();
    Feedback.hideOverlay();
  }


  Feedback.loading = function(text){
    Feedback.showOverlay();
    Feedback.initFeedback();
    if (text == null)
      text = this.settings.loadingText;

    $(this.settings.modalContent).update('<h1>' + text + '<img src="' + this.settings.loadingImage + '" /></h1>');
    $(this.settings.main).show();
  }

  Feedback.setWindowPosition = function() {
    var scrollTop, clientHeight;
    if (self.pageYOffset) {
      scrollTop = self.pageYOffset;
    } else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
      scrollTop = document.documentElement.scrollTop;
    } else if (document.body) {// all other Explorers
      scrollTop = document.body.scrollTop;
    }
    if (self.innerHeight) {	// all except Explorer
      clientHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
      clientHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
      clientHeight = document.body.clientHeight;
    }
    $(this.settings.modalWindow).setStyle({
      top: scrollTop + (clientHeight / 10) + 'px'
    });
  }
}
