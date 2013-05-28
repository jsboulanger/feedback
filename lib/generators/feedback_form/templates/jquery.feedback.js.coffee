(($) ->
  settings = undefined
  $.fn.feedback = (callerSettings) ->
    settings = $.extend(
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
    settings.feedbackHtml = "<div id=\"" + settings.main + "\" style=\"display: none;\">" + "<div id=\"" + settings.modalWindow + "\">" + "<a href=\"#\" id=\"" + settings.closeLink + "\"></a>" + "<div id=\"" + settings.modalContent + "\"></div>" + "</div>" + "</div>"
    settings.overlayHtml = "<div id=\"" + settings.overlay + "\" class=\"feedback_hide\"></div>"
    settings.tabHtml = "<a href=\"#\" id=\"feedback_link\" class=\"feedback_link " + settings.tabPosition + "\"></a>"
    settings.main = "#" + settings.main
    settings.closeLink = "#" + settings.closeLink
    settings.modalWindow = "#" + settings.modalWindow
    settings.modalContent = "#" + settings.modalContent
    settings.form = "#" + settings.form
    settings.overlay = "#" + settings.overlay
    settings.tabControls = this
    if settings.tabPosition? and $("#feedback_link").length is 0
      $("body").append settings.tabHtml
      settings.tabControls = $(settings.tabControls).add($("#feedback_link"))
    $(settings.tabControls).click ->
      loading()
      $(settings.modalContent).load settings.formUrl, null, ->
        $(settings.form).submit submitFeedback

      false

  submitFeedback = ->
    $("input[name=feedback\\[page\\]]").val location.href
    data = $(settings.form).serialize()
    url = $.trim($(settings.form).attr("action"))
    loading settings.sendingText
    $.ajax
      type: "POST"
      url: url
      data: data
      success: (msg, status) ->
        $(settings.modalContent).html msg
        $(settings.modalWindow).fadeOut 2000, ->
          hideFeedback()

      error: (xhr, status, a) ->
        $(settings.modalContent).html xhr.responseText
        $(settings.form).submit submitFeedback

    false

  initOverlay = ->
    $("body").append settings.overlayHtml  if $(settings.overlay).length is 0
    $(settings.overlay).hide().addClass "feedback_overlayBG"

  showOverlay = ->
    initOverlay().show()

  hideOverlay = ->
    return false  if $(settings.overlay).length is 0
    $(settings.overlay).remove()

  initFeedback = ->
    if $(settings.main).length is 0
      $("body").append settings.feedbackHtml
      $(settings.closeLink).click ->
        hideFeedback()
        false

      setBoxPosition()
    $ settings.main

  showFeedback = ->
    initFeedback().show()

  hideFeedback = ->
    $(settings.main).hide()
    $(settings.main).remove()
    hideOverlay()

  setBoxPosition = ->
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
    $(settings.modalWindow).css top: scrollTop + (clientHeight / 10) + "px"

  loading = (text) ->
    showOverlay()
    initFeedback()
    text = settings.loadingText  unless text?
    $(settings.modalContent).html "<h1>" + text + "<img src=\"" + settings.loadingImage + "\" /></h1>"
    showFeedback()
) jQuery
