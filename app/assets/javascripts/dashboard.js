$( document ).ready(function() {
  $( '.task-button' ).click(function() {
    var buttonText = $(this).text();
    $('#active_task_task_name').val(buttonText);
    $('#new_active_task').submit();
  });
});
