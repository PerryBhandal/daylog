// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
// TODO: I removed turoblinks down below becuase it was messing with ckeditor.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap-sprockets
//= require ckeditor-jquery

$('.ckeditor').ckeditor({
  // optional config
});

$(document).ready(function() {
  $('.collapsed-row').hide();
  $('.panel-header-collapse').click(function() {
    $(this).parents('.panel-wrapper').find('.note-panel-content-row').toggle();
  });

  $('#leisure-modal').modal({backdrop: 'static'});
  $('#leisure-modal').modal('show');
});
