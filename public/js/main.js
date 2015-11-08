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
  agreements = [];
  $('.agreement').each(function(index, el){
    agreements.push( {
      'stocks': el.querySelector("input[name='stocks']").value,
      'grantdate': el.querySelector("input[name='grantdate']").value,
      'strikeprice':el.querySelector("input[name='strikeprice']").value,
      'cliff_pct':el.querySelector("input[name='cliff_pct']").value,
      'cliff_n_months':el.querySelector("input[name='cliff_n_months']").value,
      'vesting_period':el.querySelector("input[name='vesting_period']").value
    })
  });
  return JSON.stringify({
    'market_price': $('#market_price').val(),
    'agreements': agreements
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
    'cliff_pct':  25.0,
    'cliff_n_months': 12,
    'vesting_period': 24 };

  for(field in advanced_options) {
    form_box = $("input[name='"+field+"']").parent().parent();
    $('.panel-body .row').append(form_box);
    $("input[name='"+field+"']").val(advanced_options[field]);
  }
}

function enableDupAgreement() {
  $('#add-agreement').removeClass('hidden');
  $('#add-agreement').click(function(){
    new_agreement = $('.agreement').last().clone(true, true);
    new_agreement.insertAfter($('.agreement').last());
    new_agreement.find("div[name='remove']").show();
    heading = UUID();
    collapsing = UUID();
    $('.panel-heading').last().attr('id', heading);
    $('.panel-title a').last().attr('href', '#' + collapsing);
    $('.panel-collapse').last().attr('id', collapsing);
  });
};

function enableRemove() {
  $('div[name="remove"]').click(function(ev){
    $(ev.currentTarget).parent().parent().remove();
  });
}

function UUID() {
  return '_' + Math.random().toString(36).substr(2, 9);
};

$(document).ready(function() {
  enableSubmitButton();
  enableTooltip();
  feedAdvancedOptionsPanel();
  enableDupAgreement();
  enableRemove();
})
