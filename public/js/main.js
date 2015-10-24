function submitForm() {
  $.post(
      '/spread',
      {
        "stocks": $('#stocks').val(),
        "grantdate": $('#grantdate').val(),
        "strikeprice": $('#strikeprice').val(),
        "cliff_pct": $('#cliff_pct').val(),
        "cliff_n_months": $('#cliff_n_months').val(),
        "vesting_period": $('#vesting_period').val(),
        "market_price": $('#market_price').val()
      },
      function (result){
        $('#spread').text('$ ' + Number(JSON.parse(result)['spread']).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
        $('#spread').show();
      }
  );
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
  advanced_options = ['#cliff_pct', '#cliff_n_months', '#vesting_period'];

  advanced_options.forEach(function(field){
    form_box = $(field).parent().parent();
    $('.panel-body .row').append(form_box);
  })
}

$(document).ready(function() {
  enableSubmitButton();
  enableTooltip();
  feedAdvancedOptionsPanel();
})
