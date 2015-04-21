ready = ->
  if $('.page-template').length > 0
    page_parts = $('.page-template').data('page-parts')
    show_page_parts(page_parts)

  $('.sortable-grid').sortable().bind 'sortupdate', (e) ->
    position_array = []
    $(e.target).find('li.image').each (index) ->
      position_array.push $(this).data('photo-id')
    $(e.target).parents('td').find('.photo-positions').val(position_array.join(","))

  $('.structure-form-menu ul').sortable().bind 'sortupdate', (e) ->
    $(e.target).find('li').each (index) ->
      id = $(this).data('structure-item-id')
      $(".structure_form_pane_#{id}_position").val(index)

$(document).on 'ready page:load', ready

# Change templates makes page parts appear and disappear
$(document).on 'change', '.page-template select', ->
  page_parts = $(this).find('option:selected').data('page-parts').split(" ")
  show_page_parts(page_parts)

show_page_parts = (page_parts) ->
  $('tr.page-part').hide()
  for page_part in page_parts
    $('tr.page-part[data-name=' + page_part + ']').show()

# Dynamically add and remove fields in a nested form
$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).before($(this).data('fields').replace(regexp, time))
  event.preventDefault()

$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('fieldset').slideUp()
  event.preventDefault()

# Dynamically add and remove structures
$(document).on 'click', 'form .add_structure', (event) ->
  $structureForm = $(this).parents('.structure-form')

  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $fields = $($(this).data('fields').replace(regexp, time))
  $(this).before($fields)

  $link = $("<li><a href='#structure_form_pane_#{time}'><i data-icon='7'></i> </a></li>")

  $structureForm.find('.structure-form-menu ul').append($link)
  $fields.attr('id', "structure_form_pane_#{time}")

  $link.find('a').click()

  event.preventDefault()

$(document).on 'click', 'form .remove-structure-item-fields', (event) ->
  $(this).prev('input[type=hidden]').val('1')
  $pane = $(this).closest('.structure-form-pane')
  console.log $pane.attr('id')
  $("a[href='##{$pane.attr('id')}']").parents('li').hide()
  $pane.hide()
  event.preventDefault()

# Sort pages
$(document).on 'click', '.sort-switch', (event) ->
  $($(this).attr('href') + ' .dd-item-inner').toggleClass('dd-handle')
  if $(this).attr('data-icon') == 'j'
    $(this).attr('data-icon', '8')
    $(this).removeClass('button-success')
    $(this).text($(this).data('change-order'))
  else
    $(this).attr('data-icon', 'j')
    $(this).addClass('button-success')
    $(this).text($(this).data('done-changing-order'))
  return false

# JavaScript save page
$(document).on 'submit', 'form.edit_page', (event) ->
  $submitButton = $(this).find('button[type="submit"]')
  $submitButton.addClass('button-saving')
  $submitButton.attr('data-icon', 'f')
