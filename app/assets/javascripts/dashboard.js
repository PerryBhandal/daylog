$(document).ready(function() {
  // Task button click handler
  $('.task-button').click(function() {
    var buttonText = $(this).text();
    $('#active_task_task_name').val(buttonText);
    $('#new_active_task').submit();
  });
  
  // Initialize tooltips
  if (typeof $.fn.tooltip !== 'undefined') {
    $('[data-toggle="tooltip"]').tooltip();
  }
  
  // Make panels collapsible
  $('.panel-toggle').click(function() {
    $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up');
    $(this).closest('.panel').find('.panel-body').slideToggle();
  });
  
  // Auto-refresh current time
  function updateClock() {
    var now = new Date();
    var hours = now.getHours();
    var minutes = now.getMinutes();
    var ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var timeString = hours + ':' + minutes + ' ' + ampm;
    
    // Update any time displays
    $('.current-time').text(timeString);
  }
  
  // Update time every minute
  setInterval(updateClock, 60000);
  updateClock(); // Initial update
  
  // Task form enhancements
  $('#active_task_task_name').on('keyup', function() {
    var inputVal = $(this).val().toLowerCase();
    
    // Highlight matching premade/recent tasks
    $('.task-button').each(function() {
      var buttonText = $(this).text().toLowerCase();
      if (buttonText.indexOf(inputVal) !== -1 && inputVal.length > 0) {
        $(this).addClass('btn-success').removeClass('btn-primary');
      } else {
        $(this).addClass('btn-primary').removeClass('btn-success');
      }
    });
  });
  
  // Show add form if no current task
  if ($('.alert-warning:contains("No active task")').length) {
    $('#add_form').show();
  }
  
  // Enhance the toggle add button
  $('#toggle_add_form').click(function() {
    var $icon = $(this).find('i');
    var $form = $('#add_form');
    
    if ($form.is(':visible')) {
      $(this).html('<i class="fa fa-plus"></i> Change Task');
      $form.slideUp();
    } else {
      $(this).html('<i class="fa fa-times"></i> Cancel');
      $form.slideDown();
    }
  });
});
