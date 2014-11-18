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
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
// require_tree .
//= require jsencrypt.min


function attach_password_toggle(){
  $(".password_toggle").click(function(){
    password_glyphicon_toggle("text");
    password_text_toggle();
  });
  $(".password_toggle").hover(
    function(){
      password_glyphicon_toggle("password");
      password_text_toggle();
    },
    function(){
      password_text_toggle();
      password_glyphicon_toggle("text");
    }
  );
  password_glyphicon_toggle("text");
}
function password_glyphicon_toggle(open_type){
  var element = $(".password_toggle").find("span");
  var remove_class = "glyphicon-eye-open";
  var add_class = "glyphicon-eye-close";
  if($(".input_password").attr("type") === open_type){
    remove_class = "glyphicon-eye-close";
    add_class = "glyphicon-eye-open";
  }
  element.removeClass(remove_class);
  element.addClass(add_class);
}
function password_text_toggle(){
  $(".input_password").attr("type", $(".input_password").attr("type") === "password" ? "text" : "password");
}


var encrypt = new JSEncrypt();
jQuery(function() {
  encrypt.setPublicKey($("#public_key").val());
  $("#encrypt_submit").click(function(event){
    set_encrypt_form(".input_section input");

    $.rails.disableFormElement($(this));
    $("#encrypt_form").trigger('submit.rails');
    return false;
  });

});
function set_encrypt_form(input_form_selector){
  $(input_form_selector).each(function(){
    $("#" + $(this).attr("id").replace(/^input/, "encrypt")).val(encrypt.encrypt($(this).val()));
  });
}

jQuery(function() {
  $("#locale .dropdown-menu a").click(function(event){
    location.href = location.pathname + "?locale=" + $(this).data('locale');
    return false;
  });
});

var stored_values = {};
function store_values(){
  $(".store_value").each(function(){
    stored_values[$(this).attr("name")] = $(this).val();
  });
}
function restore_values(){
  $.each(stored_values, function(name, value){
    $(".store_value[name=\"" + name + "\"]").val(value);
  });
}