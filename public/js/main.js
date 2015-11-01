function submitForm() {
  $.ajax({
    type: 'POST',
    url: '/spread',
    data: build_form_params(),
    success: function (result){
      $('#spread').text('$ ' + Number(JSON.parse(result)['spread']).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
      $('#spread').show();
    }
  });
}

function build_form_params(){
  return JSON.stringify({
    'market_price': $('#market_price').val(),
    'agreements': [{
      'stocks': $('#stocks').val(),
      'grantdate': $('#grantdate').val(),
      'strikeprice': $('#strikeprice').val(),
      'cliff_pct': $('#cliff_pct').val(),
      'cliff_n_months': $('#cliff_n_months').val(),
      'vesting_period': $('#vesting_period').val(),
    }]
  });
}

function enableSubmitButton(){
  $("#form").submit(function(e){
    e.preventDefault();
    submitForm();
  });
}

function enableTooltip() {
  $('[data-toggle="tooltip"]').tooltip()
}

function feedAdvancedOptionsPanel(){
  advanced_options = {
    '#cliff_pct':  25.0,
    '#cliff_n_months': 12,
    '#vesting_period': 24 };

  for(field in advanced_options) {
    form_box = $(field).parent().parent();
    $('.panel-body .row').append(form_box);
    $(field).val(advanced_options[field]);
  }
}

function enableDupAgreement() {
  $('#add-agreement').removeClass('hidden');
  $('#add-agreement').click(function(){
    new_agreement = $('.agreement').last().clone(false, false);
    new_agreement.insertAfter($('.agreement').last())
  });
};

function UUID() {
  return '_' + Math.random().toString(36).substr(2, 9);
};

$(document).ready(function() {
  enableSubmitButton();
  enableTooltip();
  feedAdvancedOptionsPanel();
  //enableDupAgreement();
})
