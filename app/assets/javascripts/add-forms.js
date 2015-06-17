$(document).on('ready page:load', function(){

  addForm('#add-guest', '/guests/new', 'GET');

  var placeId = $('#add-key').data('place-id')

  addForm('#add-key', '/keys?place_id=' + placeId, 'POST');
  addForm('#add-place', '/places/new', 'GET');

  $('#form-drop-down').on('click', '.secret-url', function(event){
    this.select();
  })

  // cancelForm('#add-key');
  // cancelForm('#add-place');

})

var addForm = function(selector, url, method, data) {
  $(selector).on('click', function(event){
    if (($('#form-drop-down').html().length) > 4 ){
      cancelForm(selector);
    }
    else{

      //     $(window).animate({
      //     scrollTop: $(".col-md-12 text-center").offset().top
      // }, 2000);
      // $(window).scrollTop(".col-md-12 text-center");
      $.ajax({
        method: method,
        url: url,
      })
      .done(function ( response ) {
        if (selector == '#add-place') {
          dropDownFooter = "<br>"
        }
        response = response + dropDownFooter;
        $('#form-drop-down').html(response).hide();
        $('#form-drop-down').slideToggle( "slow" )
        if (selector == '#add-key') {
          $('#add-key').hide();
          $('#form-drop-down').find('#cancel-form').addClass('delete-key')
          $("#form-drop-down").find(".secret-url").select();
        }
      })
      .fail(function(jqXHR,textStatus){
        /* code ... */
      })
      .always(function(jqXHR,textStatus){
        /* code ... */
      });
    }
  });
}

var cancelForm = function(selector){
  $('#form-drop-down').slideToggle( "slow", function(){
    $('#form-drop-down').html('');
    $('#form-drop-down').show();
  } )
  // $('#form-drop-down').show();
}


var dropDownFooter =
  "<div class='container-fluid cancel-container col-md-12'>"+
  "<br><a href='/' class='pull-left' id='cancel-form'><i class='fa fa-trash-o'></i> Delete Key </a>"+
  "<a href='/im_done' class='pull-right' id='close-and-save'><i class='fa fa-check'></i> I'm done</p></a>" +
  "<br>" +
  "</div>";