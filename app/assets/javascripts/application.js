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
//= require bootstrap
//= require ckeditor-jquery
//= require_tree .

// Initialize CKEditor
$('.ckeditor').ckeditor({
  // optional config
});

// Load Chart.js from CDN
document.addEventListener('DOMContentLoaded', function() {
  if (typeof Chart === 'undefined') {
    var script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js';
    script.integrity = 'sha512-d9xgZrVZpmmQlfonhQUvTR7lMPtO7NkZMkA0ABN3PHCbKA5nqylQ/yWlFAyY6hYgdF1Qh6nYiuADWwKB4C2WSw==';
    script.crossOrigin = 'anonymous';
    document.head.appendChild(script);
  }
});

$(document).ready(function() {
  // Legacy code for old panels
  $('.collapsed-row').hide();
  $('.panel-header-collapse').click(function() {
    $(this).parents('.panel-wrapper').find('.note-panel-content-row').toggle();
  });

  // Initialize all tooltips
  if (typeof $.fn.tooltip !== 'undefined') {
    $('[data-toggle="tooltip"]').tooltip();
  }
  
  // Make all panels with .panel-collapsible class collapsible
  $('.panel-collapsible .panel-heading').click(function() {
    $(this).find('.panel-toggle i').toggleClass('fa-chevron-down fa-chevron-up');
    $(this).closest('.panel').find('.panel-body').slideToggle();
  });
});
