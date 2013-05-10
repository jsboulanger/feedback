Feedback = undefined
if Feedback is `undefined`
  Feedback = {}
  Feedback.init = (callerSettings) ->
    @settings = Object.extend(
      tabControl: "feedback_link"
      main: "feedback"
      closeLink: "feedback_close_link"
      modalWindow: "feedback_modal_window"
      modalContent: "feedback_modal_content"
      form: "feedback_form"
      formUrl: "/feedbacks/new"
      overlay: "feedback_overlay"
      loadingImage: "/assets/feedback/loading.gif"
      loadingText: "Loading..."
      sendingText: "Sending..."
      tabPosition: "left"
    , callerSettings or {})
    @settings.feedbackHtml = "<div id=\"" + @settings.main + "\" style=\"display: none;\">" + "<div id=\"" + @settings.modalWindow + "\">" + "<a href=\"#\" id=\"" + @settings.closeLink + "\"></a>" + "<div id=\"" + @settings.modalContent + "\"></div>" + "</div>" + "</div>"
    @settings.overlayHtml = "<div id=\"" + @settings.overlay + "\" class=\"feedback_hide\"></div>"
    @settings.tabHtml = "<a href=\"#\" id=\"feedback_link\" class=\"" + @settings.tabControl + " " + @settings.tabPosition + "\"></a>"
    $$("body").first().insert @settings.tabHtml  if @settings.tabPosition? and $$("#" + @settings.tabControl).length is 0
    $$("." + @settings.tabControl).each (e) ->
      $(e).observe "click", ->
        Feedback.loading()
        new Ajax.Updater(Feedback.settings.modalContent, Feedback.settings.formUrl,
          method: "get"
          onComplete: (transport) ->
            $(Feedback.settings.form).observe "submit", Feedback.submitFeedback
        )
        false

  Feedback.submitFeedback = (event) ->
    $("feedback_page").value = location.href
    data = Form.serialize($(Feedback.settings.form))
    url = $(Feedback.settings.form).action
    Feedback.loading Feedback.settings.sendingText
    new Ajax.Updater(Feedback.settings.modalContent, url,
      method: "POST"
      parameters: data
      onComplete: (transport) ->
        if transport.status >= 200 and transport.status < 300
          $(Feedback.settings.modalWindow).fade
            duration: 2.0
            afterFinish: ->
              Feedback.hideFeedback()
        else
          $(Feedback.settings.form).observe "submit", Feedback.submitFeedback
    )
    Event.stop event

  Feedback.initOverlay = ->
    $$("body").first().insert @settings.overlayHtml  if $$("#" + @settings.overlay).length is 0
    $(@settings.overlay).addClassName "feedback_overlayBG"

  Feedback.showOverlay = ->
    Feedback.initOverlay()
    $(@settings.overlay).show()

  Feedback.hideOverlay = ->
    return false  if $$("#" + @settings.overlay).length is 0
    $(@settings.overlay).remove()

  Feedback.initFeedback = ->
    if $$("#" + @settings.main).length is 0
      $$("body").first().insert @settings.feedbackHtml
      $(@settings.closeLink).observe "click", ->
        Feedback.hideFeedback()
        false

      Feedback.setWindowPosition()

  Feedback.showFeedback = ->
    Feedback.initFeedback()
    $(@settings.main).show()

  Feedback.hideFeedback = ->
    $(@settings.main).hide()
    $(@settings.main).remove()
    Feedback.hideOverlay()

  Feedback.loading = (text) ->
    Feedback.showOverlay()
    Feedback.initFeedback()
    text = @settings.loadingText  unless text?
    $(@settings.modalContent).update "<h1>" + text + "<img src=\"" + @settings.loadingImage + "\" /></h1>"
    $(@settings.main).show()

  Feedback.setWindowPosition = ->
    scrollTop = undefined
    clientHeight = undefined
    if self.pageYOffset
      scrollTop = self.pageYOffset
    else if document.documentElement and document.documentElement.scrollTop
      scrollTop = document.documentElement.scrollTop
    else scrollTop = document.body.scrollTop  if document.body
    if self.innerHeight
      clientHeight = self.innerHeight
    else if document.documentElement and document.documentElement.clientHeight
      clientHeight = document.documentElement.clientHeight
    else clientHeight = document.body.clientHeight  if document.body
    $(@settings.modalWindow).setStyle top: scrollTop + (clientHeight / 10) + "px"
