$(document).on('ready page:load', function(){

  $('#form-drop-down').on('click', '.delete-key', function(event){
    var keyId = $('#form-drop-down').find('.secret-url').data('key-id');
    deleteKey(keyId);
  })

  $('#form-drop-down').on('click', '#cancel-form', function(event){
    event.preventDefault();
    $('#form-drop-down').html('');
    $('#add-key').show();
    clearInterval(refreshTime);
  });

  $('#keys_container').on('click','.del-key-remove',function(event){
    event.preventDefault();
    var keyId = $(event.target).data('key-id');
    deleteKey(keyId,true);
  });

});

var removeKeyFromDom = function(keyId){
  $("#key_" + keyId).remove();
}

var deleteKey = function(keyId,remove){
  $.ajax({
      url: '/keys/' + keyId,
      method: 'delete'
    })
    .done(function ( data ) {
      if(remove){
        removeKeyFromDom(keyId);
      }
    })
    .fail(function(jqXHR,textStatus){
      /* code ... */
    })
    .always(function(jqXHR,textStatus){
      /* code ... */
    });
}